#![cfg_attr(not(test), no_std)]

#[cfg(feature = "midi-config")]
use config::ConfigEvent;
use defmt::{Format, info};
use embassy_sync::{blocking_mutex::raw::RawMutex, channel::Sender};
use midly::{MidiMessage, live::LiveEvent, stream::MidiStream};

pub use midly::num::u7;

#[derive(Format, Debug, Clone, Copy, PartialEq, Eq)]
pub enum NoteEvent {
    NoteOff { key: u8, vel: u8 },
    NoteOn { key: u8, vel: u8 },
}

pub struct MidiListener<
    'ch,
    M1: RawMutex,
    const N1: usize,
    #[cfg(feature = "midi-config")] M2: RawMutex,
    #[cfg(feature = "midi-config")] const N2: usize,
> {
    note_sender: Sender<'ch, M1, NoteEvent, N1>,
    #[cfg(feature = "midi-config")]
    config_sender: Sender<'ch, M2, ConfigEvent, N2>,
    midi_stream: MidiStream<MidiListenerBuffer>,
}

midly::stack_buffer! {
    struct MidiListenerBuffer([u8; 4]);
}

#[cfg(not(feature = "midi-config"))]
impl<'ch, M1: RawMutex, const N1: usize> MidiListener<'ch, M1, N1> {
    pub fn new(note_sender: Sender<'ch, M1, NoteEvent, N1>) -> Self {
        let midi_stream = MidiStream::with_buffer(MidiListenerBuffer::new());

        MidiListener {
            note_sender,
            midi_stream,
        }
    }

    fn handle_event(note_sender: &Sender<'ch, M1, NoteEvent, N1>, event: LiveEvent<'_>) {
        if let LiveEvent::Midi {
            channel: _,
            message,
        } = event
        {
            let note_event: Option<_> = match message {
                MidiMessage::NoteOff { key, vel } => Some(NoteEvent::NoteOff {
                    key: key.into(),
                    vel: vel.into(),
                }),
                MidiMessage::NoteOn { key, vel } => Some(NoteEvent::NoteOn {
                    key: key.into(),
                    vel: vel.into(),
                }),
                _ => None,
            };

            if let Some(note_event) = note_event {
                info!("Adding note event: {:#?}", note_event);
                // Only fails if full. In practice this never happens
                note_sender.try_send(note_event).ok();
            }
        }
    }

    pub fn process_bytes(&mut self, bytes: &[u8]) {
        self.midi_stream
            .feed(bytes, |event| Self::handle_event(&self.note_sender, event));
    }
}

#[cfg(feature = "midi-config")]
impl<'ch, M1: RawMutex, const N1: usize, M2: RawMutex, const N2: usize>
    MidiListener<'ch, M1, N1, M2, N2>
{
    pub fn new(
        note_sender: Sender<'ch, M1, NoteEvent, N1>,
        config_sender: Sender<'ch, M2, ConfigEvent, N2>,
    ) -> Self {
        let midi_stream = MidiStream::with_buffer(MidiListenerBuffer::new());

        MidiListener {
            note_sender,
            config_sender,
            midi_stream,
        }
    }

    fn handle_event(
        note_sender: &Sender<'ch, M1, NoteEvent, N1>,
        config_sender: &Sender<'ch, M2, ConfigEvent, N2>,
        event: LiveEvent<'_>,
    ) {
        if let LiveEvent::Midi {
            channel: _,
            message,
        } = event
        {
            let note_event: Option<_> = match message {
                MidiMessage::NoteOff { key, vel } => Some(NoteEvent::NoteOff {
                    key: key.into(),
                    vel: vel.into(),
                }),
                MidiMessage::NoteOn { key, vel } => Some(NoteEvent::NoteOn {
                    key: key.into(),
                    vel: vel.into(),
                }),
                _ => None,
            };

            if let Some(note_event) = note_event {
                info!("Adding note event: {:#?}", note_event);
                // Only fails if full. In practice this never happens
                note_sender.try_send(note_event).ok();
            }

            let config_event: Option<_> = match message {
                MidiMessage::Controller { controller, value } => {
                    if controller >= 102 {
                        let controller = u8::from(controller) - 102;
                        let page = controller / 3;
                        let encoder = controller % 3;
                        let value = u8::from(value) * 2;
                        Some(ConfigEvent::SetValue {
                            page,
                            encoder,
                            value,
                        })
                    } else {
                        None
                    }
                }
                _ => None,
            };

            if let Some(config_event) = config_event {
                info!("Adding config event: {:#?}", config_event);
                // Only fails if full. In practice this never happens
                config_sender.try_send(config_event).ok();
            }
        }
    }

    pub fn process_bytes(&mut self, bytes: &[u8]) {
        self.midi_stream.feed(bytes, |event| {
            Self::handle_event(&self.note_sender, &self.config_sender, event)
        });
    }
}

#[cfg(test)]
mod test;
