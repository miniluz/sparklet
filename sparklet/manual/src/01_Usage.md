# Usage

## Configuration before compilation

Sparklet is configured through the `Config.toml` file on the `sparklet/runner/` directory. An example is provided in the
`Config.example.toml` file, which you should copy and rename. The file should be fairly self-documenting. Here are its
contents:

```toml
[chip]
model = "stm32h723zg"
# model = "stm32f401rc"

[connections]
midi = "usb"
# midi = "din"
# midi = "none"

audio = "usb"
# audio = "none"

[features]
octave_filter = true
configurable = true

[parameters]
polyphony = 16
# Increase it to make the encoders more responsive.
# Make it negative to invert them.
encoder_multiplier = 4
# How often to poll peripherals for changes in milliseconds
config_poll_millis = 5
# How often to update the config in milliseconds
config_update_millis = 100

[initial_config]
# All values in this section are in the range 0 to 255
attack = 40
sustain = 127
decay_release = 200
# Wavetable depends on the value mod 4
#   0 => Sine
#   1 => Saw
#   2 => Square
#   3 => Triangle
oscillator_type = 1
# Equalizer
f250hz = 200
f500hz = 200
f1000hz = 200
f2000hz = 200
f4000hz = 200
f8000hz = 200
```

## At runtime

If `features.configurable` is enabled, Sparklet will be configurable at runtime through three rotative encoders
(knobs) and two buttons. Sparklet follows a pagination format, and should boot on page 0. The buttons are used to
switch between the pages, wrapping around.

Page 0 controls the ADSR, with the first encoder controlling the attack, the second the sustain level and the third
the decay and release. Decay and release are controlled together since Sparklet emulates how capacitors were used to
shape the amplitude on old synths.

Page 1 will control the oscillator, which for now only entails controlling the wave type on the first encoder.

Page 2 and 3 will control the multiband equalizer, if it's enabled. If not, they will not exist, and the buttons will
wrap back to page 0 when advancing from page 1. The first page controls the three lowest bands of the equalizer, with
the first encoder controlling the lowest band, the second encoder the second lowest of the three, etc. The second page
controls the three highest bands in a similar manner. The bands correspond to 250 Hz and lower, 500 Hz, 1000 Hz,
2000 Hz, 4000 Hz and 8000 Hz and higher.
