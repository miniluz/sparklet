use crate::hardware::usb::USB_MODE;
use config::ConfigEvent;
use defmt::trace;
use embassy_executor::SpawnToken;
use embassy_stm32::usb;
use embassy_sync::{
    blocking_mutex::raw::{CriticalSectionRawMutex, NoopRawMutex},
    channel::Sender,
};
use embassy_usb::class::midi::MidiClass;
use embassy_usb::driver::EndpointError;
use midi::MidiListener;
use static_cell::StaticCell;

use crate::{
    config::CONFIG_CHANNEL_SIZE,
    hardware::midi_usb::MidiUsbHardware,
    midi_task::{MIDI_CHANNEL_SIZE, MIDI_TASK_CHANNEL},
};

#[cfg(not(feature = "midi-config"))]
pub struct MidiTaskState<'a> {
    midi_listener: MidiListener<'a, CriticalSectionRawMutex, MIDI_CHANNEL_SIZE>,
    midi_class: MidiClass<'a, usb::Driver<'a, USB_MODE>>,
}

#[cfg(feature = "midi-config")]
pub struct MidiTaskState<'a> {
    midi_listener: MidiListener<
        'a,
        CriticalSectionRawMutex,
        MIDI_CHANNEL_SIZE,
        NoopRawMutex,
        CONFIG_CHANNEL_SIZE,
    >,
    midi_class: MidiClass<'a, usb::Driver<'a, USB_MODE>>,
}

pub static MIDI_TASK_STATE: StaticCell<MidiTaskState> = StaticCell::new();

pub fn create_midi_task(
    midi_hardware: MidiUsbHardware<'static>,
    #[cfg(feature = "midi-config")] config_sender: Sender<
        'static,
        NoopRawMutex,
        ConfigEvent,
        CONFIG_CHANNEL_SIZE,
    >,
) -> SpawnToken<impl Sized> {
    let midi_class = midi_hardware.midi_class;
    let midi_sender = MIDI_TASK_CHANNEL.sender();

    #[cfg(not(feature = "midi-config"))]
    let midi_listener = MidiListener::new(midi_sender);

    #[cfg(feature = "midi-config")]
    let midi_listener = MidiListener::new(midi_sender, config_sender);

    midi_task(MIDI_TASK_STATE.init(MidiTaskState {
        midi_listener,
        midi_class,
    }))
}

struct Disconnected {}

impl From<EndpointError> for Disconnected {
    fn from(val: EndpointError) -> Self {
        match val {
            EndpointError::BufferOverflow => defmt::panic!("Buffer overflow"),
            EndpointError::Disabled => Disconnected {},
        }
    }
}

async fn midi_handler(state: &mut MidiTaskState<'static>) -> Result<(), Disconnected> {
    let mut buffer = [0; 64];
    loop {
        let n = state.midi_class.read_packet(&mut buffer).await?;

        // USB MIDI packets are 4 bytes: [Cable/CIN][MIDI1][MIDI2][MIDI3]
        // Process in 4-byte chunks
        for chunk in buffer[..n].chunks_exact(4) {
            // Extract the 3 MIDI bytes (skip first byte which is USB-specific)
            let midi_bytes = &chunk[1..4];
            state.midi_listener.process_bytes(midi_bytes);
        }
    }
}

#[embassy_executor::task]
pub async fn midi_task(state: &'static mut MidiTaskState<'static>) {
    loop {
        state.midi_class.wait_connection().await;
        trace!("USB MIDI connected");

        let _ = midi_handler(state).await;

        trace!("USB MIDI disconnected");
    }
}
