# Introduction

Sparklet is a polyphonic synthesizer designed to be run in a wide gamut of hardware. In particular, it should be able to
run in most ARM Cortex M4 or M7 chips. It features:

- **High voice count**, which is configurable (12 on STM32H723ZG, 8 on STM32F401RC).
- A newfangled voice stealing algorithm that responds quickly (without artifacts!).
- An interpolated **wavetable oscillator** featuring sine, saw, triangle and square waves.
- A dynamically configurable **ADSR** envelope (also without artifacts!).
- A dynamically configurable **multi-band equalizer** that's not-quite flat!
- **MIDI** through USB or a DIN port.
- **USB audio output** (ideally, analogue would come sometime soon).
- **Configurable from a file** to enable and disable features to fit your needs and your chip's power:
  - Select which chip to run it on.
  - Select if you want to use MIDI through DIN or USB.
  - Select if you want to use audio output through USB (or analogue, when it's implemented).
  - Specify the voice limit.
  - Specify the initial configuration.
  - Pick if you want the equalizer to be included.
  - Specify if you want the synthesizer to be configurable at runtime.

## Contributing

Sparklet is TODO, under the TODO license. Feel free to contribute on
[GitHub](https://github.com/miniluz/sparklet). If you need any help, creating an issue there will also be your best bet.
If you add support for a new device, please open a PR so the community might benefit!
