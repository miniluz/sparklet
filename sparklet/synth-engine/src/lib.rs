#![cfg_attr(not(test), no_std)]

pub mod adsr;
pub mod capacitor;
pub mod db_linear_amplitude_table;
#[cfg(feature = "equalizer")]
pub mod equalizer;
pub mod generator;
mod voice_bank;
pub mod wavetable;

/// Default number of samples to process in each render cycle
/// Used in tests and examples
pub const WINDOW_SIZE: usize = 128;

/// Sample rate in Hz
pub const SAMPLE_RATE: u32 = 48000;

use amity::triple::{TripleBuffer, TripleBufferConsumer};
use config::Config;
use embassy_sync::{blocking_mutex::raw::RawMutex, channel::Receiver};
use midi::MidiEvent;

pub use cmsis_interface::{CmsisOperations, Q15};
#[cfg(feature = "equalizer")]
pub use equalizer::Equalizer;
pub use generator::Generator;
pub use voice_bank::{Note, PlayNoteResult, Velocity, VoiceBank, VoiceStage};

pub struct SynthEngine<
    'ch,
    'wt,
    'buf,
    M: RawMutex,
    const CHANNEL_SIZE: usize,
    const VOICE_BANK_SIZE: usize,
    const WINDOW_SIZE: usize,
    const PAGE_AMOUNT: usize,
    const ENCODER_AMOUNT: usize,
    const EQUALIZER_FIRST_PAGE: usize,
> {
    generator: Generator<
        'ch,
        'wt,
        M,
        CHANNEL_SIZE,
        VOICE_BANK_SIZE,
        WINDOW_SIZE,
        PAGE_AMOUNT,
        ENCODER_AMOUNT,
    >,
    #[cfg(feature = "equalizer")]
    equalizer: Equalizer,
    config_consumer: TripleBufferConsumer<
        Config<PAGE_AMOUNT, ENCODER_AMOUNT>,
        &'buf TripleBuffer<Config<PAGE_AMOUNT, ENCODER_AMOUNT>>,
    >,
}

impl<
    'ch,
    'wt,
    'buf,
    M: RawMutex,
    const CHANNEL_SIZE: usize,
    const VOICE_BANK_SIZE: usize,
    const WINDOW_SIZE: usize,
    const PAGE_AMOUNT: usize,
    const ENCODER_AMOUNT: usize,
    const EQUALIZER_FIRST_PAGE: usize,
>
    SynthEngine<
        'ch,
        'wt,
        'buf,
        M,
        CHANNEL_SIZE,
        VOICE_BANK_SIZE,
        WINDOW_SIZE,
        PAGE_AMOUNT,
        ENCODER_AMOUNT,
        EQUALIZER_FIRST_PAGE,
    >
{
    pub fn new(
        receiver: Receiver<'ch, M, MidiEvent, CHANNEL_SIZE>,
        config_consumer: TripleBufferConsumer<
            Config<PAGE_AMOUNT, ENCODER_AMOUNT>,
            &'buf TripleBuffer<Config<PAGE_AMOUNT, ENCODER_AMOUNT>>,
        >,
    ) -> Self {
        let initial_config = config_consumer.get();
        Self {
            generator: Generator::new(receiver, initial_config),
            #[cfg(feature = "equalizer")]
            equalizer: Equalizer::new(),
            config_consumer,
        }
    }

    pub fn get_voice_bank(&self) -> &VoiceBank<'wt, 'ch, M, VOICE_BANK_SIZE, CHANNEL_SIZE> {
        self.generator.get_voice_bank()
    }

    pub fn check_and_apply_config(&mut self) {
        if self.config_consumer.published() {
            self.config_consumer.consume();
            let config = self.config_consumer.get();
            self.generator.apply_config(config);

            #[cfg(feature = "equalizer")]
            self.equalizer
                .set_band_gains_from_config::<_, _, EQUALIZER_FIRST_PAGE>(config);
        }
    }

    pub fn render_samples<T: CmsisOperations>(&mut self, output_samples: &mut [Q15; WINDOW_SIZE]) {
        self.check_and_apply_config();

        #[cfg(not(feature = "equalizer"))]
        {
            self.generator.render_samples::<T>(output_samples);
        }

        #[cfg(feature = "equalizer")]
        {
            let mut buffer = [Q15::ZERO; WINDOW_SIZE];
            self.generator.render_samples::<T>(&mut buffer);
            self.equalizer
                .process::<T, WINDOW_SIZE>(&buffer, output_samples);
        }
    }
}
