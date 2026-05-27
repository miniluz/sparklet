use config::{ConfigEvent, ConfigManager};
use defmt::info;
use embassy_executor::SpawnToken;
use embassy_sync::{blocking_mutex::raw::NoopRawMutex, channel::Receiver};
use embassy_time::{Duration, Ticker};
use static_cell::StaticCell;

use crate::{
    build_config::BUILD_CONFIG,
    config::{
        CONFIG_CHANNEL_SIZE, CONFIG_ENCODER_COUNT, CONFIG_PAGE_COUNT, ConfigProducer,
        INITIAL_CONFIG,
    },
};

const CONFIG_POLL_MILLIS: u16 = BUILD_CONFIG.parameters.config_poll_millis;
const CONFIG_UPDATE_RATE: u32 =
    (BUILD_CONFIG.parameters.config_update_millis / CONFIG_POLL_MILLIS) as u32;

pub struct ConfigTaskState<'a> {
    config_manager: ConfigManager<'a, CONFIG_PAGE_COUNT, CONFIG_ENCODER_COUNT>,
    need_to_update: bool,
    counter: u32,
}

impl<'a> ConfigTaskState<'a> {
    pub fn new(producer: ConfigProducer) -> Self {
        Self {
            config_manager: ConfigManager::from_config(producer, INITIAL_CONFIG),
            need_to_update: false,
            counter: 0,
        }
    }

    pub fn handle_event(&mut self, event: ConfigEvent) {
        if self.config_manager.handle_event(event) {
            self.need_to_update = true;
        }
    }
}

static CONFIG_STATE: StaticCell<ConfigTaskState> = StaticCell::new();

pub fn create_task(
    producer: ConfigProducer,
    receiver: Receiver<'static, NoopRawMutex, ConfigEvent, CONFIG_CHANNEL_SIZE>,
) -> SpawnToken<impl Sized> {
    config_task(CONFIG_STATE.init(ConfigTaskState::new(producer)), receiver)
}

#[embassy_executor::task]
pub async fn config_task(
    state: &'static mut ConfigTaskState<'static>,
    receiver: Receiver<'static, NoopRawMutex, ConfigEvent, CONFIG_CHANNEL_SIZE>,
) {
    info!("Config task started");

    let mut ticker = Ticker::every(Duration::from_millis(CONFIG_POLL_MILLIS.into()));

    loop {
        ticker.next().await;

        while let Ok(config_event) = receiver.try_receive() {
            state.handle_event(config_event)
        }

        if state.counter.is_multiple_of(CONFIG_UPDATE_RATE) && state.need_to_update {
            state.config_manager.publish_config();
            state.need_to_update = false;
        }

        state.counter = (state.counter + 1) % CONFIG_UPDATE_RATE;
    }
}
