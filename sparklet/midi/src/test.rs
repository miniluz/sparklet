#![cfg(feature = "midi-config")]

use config::ConfigEvent;
use embassy_sync::{blocking_mutex::raw::NoopRawMutex, channel::Channel};
use midly::{
    MidiMessage,
    live::{LiveEvent, SystemCommon},
};
use pretty_assertions::assert_eq;

use crate::{MidiListener, NoteEvent};

macro_rules! setup {
    ($note_receiver:ident, $config_receiver:ident, $midi_listener:ident) => {
        let note_channel = Channel::<NoopRawMutex, NoteEvent, 4>::new();
        let note_sender = note_channel.sender();
        let $note_receiver = note_channel.receiver();

        let config_channel = Channel::<NoopRawMutex, ConfigEvent, 4>::new();
        let config_sender = config_channel.sender();
        let $config_receiver = config_channel.receiver();

        let mut $midi_listener = MidiListener::new(note_sender, config_sender);
    };
}

macro_rules! note_on {
    ($channel:expr, $key:expr, $vel:expr) => {
        LiveEvent::Midi {
            channel: $channel.into(),
            message: MidiMessage::NoteOn {
                key: $key.into(),
                vel: $vel.into(),
            },
        }
    };
}

macro_rules! note_off {
    ($channel:expr, $key:expr, $vel:expr) => {
        LiveEvent::Midi {
            channel: $channel.into(),
            message: MidiMessage::NoteOff {
                key: $key.into(),
                vel: $vel.into(),
            },
        }
    };
}

macro_rules! controller {
    ($channel:expr, $controller:expr, $value:expr) => {
        LiveEvent::Midi {
            channel: $channel.into(),
            message: MidiMessage::Controller {
                controller: $controller.into(),
                value: $value.into(),
            },
        }
    };
}

#[test]
fn when_overflowing_it_discards_the_overflow() {
    setup!(note_receiver, config_receiver, midi_listener);

    let sample_midi = [
        note_on!(0, 0, 0),
        note_off!(0, 1, 1),
        note_on!(0, 2, 2),
        note_off!(0, 3, 3),
        note_on!(0, 4, 4),
        note_off!(0, 5, 5),
        controller!(0, 102, 0),
        controller!(0, 103, 1),
        controller!(0, 104, 2),
        controller!(0, 105, 3),
        controller!(0, 106, 4),
        controller!(0, 107, 5),
    ];

    let mut input_buffer: Vec<u8> = Vec::new();

    sample_midi
        .iter()
        .for_each(|ev| ev.write(&mut input_buffer).unwrap());

    midi_listener.process_bytes(&input_buffer);

    let mut note_output_buffer: Vec<NoteEvent> = Vec::new();

    while let Ok(event) = note_receiver.try_receive() {
        note_output_buffer.push(event);
    }

    assert_eq!(
        note_output_buffer.as_slice(),
        &[
            NoteEvent::NoteOn { key: 0, vel: 0 },
            NoteEvent::NoteOff { key: 1, vel: 1 },
            NoteEvent::NoteOn { key: 2, vel: 2 },
            NoteEvent::NoteOff { key: 3, vel: 3 },
        ]
    );

    let mut config_output_buffer: Vec<ConfigEvent> = Vec::new();

    while let Ok(event) = config_receiver.try_receive() {
        config_output_buffer.push(event);
    }

    assert_eq!(
        config_output_buffer.as_slice(),
        &[
            ConfigEvent::SetValue {
                page: 0,
                encoder: 0,
                value: 0
            },
            ConfigEvent::SetValue {
                page: 0,
                encoder: 1,
                value: 2
            },
            ConfigEvent::SetValue {
                page: 0,
                encoder: 2,
                value: 4
            },
            ConfigEvent::SetValue {
                page: 1,
                encoder: 0,
                value: 6
            },
        ]
    );
}

#[test]
fn when_receiving_from_multiple_channels_it_processes_all_of_them() {
    setup!(receiver, _config_receiver, midi_listener);

    let sample_midi = [
        note_on!(0, 0, 0),
        note_off!(1, 1, 1),
        note_on!(2, 2, 2),
        note_off!(3, 3, 3),
    ];

    let mut input_buffer: Vec<u8> = Vec::new();

    sample_midi
        .iter()
        .for_each(|ev| ev.write(&mut input_buffer).unwrap());

    midi_listener.process_bytes(&input_buffer);

    let mut output_buffer: Vec<NoteEvent> = Vec::new();

    while let Ok(event) = receiver.try_receive() {
        output_buffer.push(event);
    }

    assert_eq!(
        output_buffer.as_slice(),
        &[
            NoteEvent::NoteOn { key: 0, vel: 0 },
            NoteEvent::NoteOff { key: 1, vel: 1 },
            NoteEvent::NoteOn { key: 2, vel: 2 },
            NoteEvent::NoteOff { key: 3, vel: 3 },
        ]
    );
}

#[test]
fn when_receiving_garbage_it_processes_the_midi() {
    setup!(receiver, _config_receiver, midi_listener);

    let sysex_contents = [8.into()].repeat(1000);
    let sysex = LiveEvent::Common(SystemCommon::SysEx(sysex_contents.as_slice()));

    let sample_midi = [
        note_on!(0, 0, 0),
        note_off!(1, 1, 1),
        sysex,
        note_on!(2, 2, 2),
        note_off!(3, 3, 3),
    ];

    let mut input_buffer: Vec<u8> = Vec::new();

    sample_midi[0..2]
        .iter()
        .for_each(|ev| ev.write(&mut input_buffer).unwrap());

    // add random data
    input_buffer
        .append(&mut [0x90, 0xf1, 0x56, 0x3e, 0xe3, 0x0d, 0x87, 0x78, 0xd1, 0xc4].repeat(1000));

    sample_midi[2..]
        .iter()
        .for_each(|ev| ev.write(&mut input_buffer).unwrap());

    midi_listener.process_bytes(&input_buffer);

    let mut output_buffer: Vec<NoteEvent> = Vec::new();

    while let Ok(event) = receiver.try_receive() {
        output_buffer.push(event);
    }

    assert_eq!(
        output_buffer.as_slice(),
        &[
            NoteEvent::NoteOn { key: 0, vel: 0 },
            NoteEvent::NoteOff { key: 1, vel: 1 },
            NoteEvent::NoteOn { key: 2, vel: 2 },
            NoteEvent::NoteOff { key: 3, vel: 3 },
        ]
    );
}
