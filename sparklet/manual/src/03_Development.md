# Development

## Contributing

I am open to contributions, particularly regarding the support of more devices!

For other features, like reverb, etc., please open an issue. One of the goals of this project is to support a wide
array of hardware options so each person might buy or use what's available to them. Thus, the performance of these
features and compatibility needs to be discussed. However, don't be discouraged! As long as it's viable, I'm willing
to help make it happen.

## Development environment

For development, do what's specified in the [Installation](./02_Installation.md) section's prerequisites. However, you
will simply use `nix-shell` to obtain the development shell. Alternatively, you may want to install
[direnv](https://direnv.net/docs/installation.html) and [nix-direnv](https://github.com/nix-community/nix-direnv), which
will load the development environment whenever you change into the shell.

## Structure

* `flake.nix`, `flake.lock`, `shell.nix`, `.envrc`: Nix is used to provide the tools for development.
* `experiments/`: Small projects made to test out parts of the system. Only included since this project is my thesis.
* `thesis/`: Similarly, the source code for the document of my thesis.
* `sparklet/`: Full code for Sparklet, the project. It's spread across modules.
  * `cmsis-interface/`, `cmsis-native/`, `cmsis-rust/`: Modules handling DSP operations. An interface is provided so
    that modules may use a Rust implementation when being run in tests and a CMSIS-DSP based implementation for the chip.
  * `config/`: Manages runtime configuration.
  * `midi/`: Manages MIDI bytes. The actual input is in `runner/`.
  * `synth-engine/`: The logic for rendering, including the oscillator, ADSR, voice bank, EQ, etc.
  * `table-generators/`: Generates Q15 constants used for ADSR, the filter bank, and the wavetables.
  * `runner/`: Logic used to actually run the chip.
    * `hardware/`: Hardware-specific logic, mostly pins and hardware configuration.

## Tools

* The Rust toolchain is used for development
  * `bacon` will run the linter constantly on reload.
  * `cargo-binutils`, `cargo-expand` and `cargo-bloat` are useful for analyzing the size of the executable
  * `cargo-nextest` is used for running tests.
  * `lldb` is provided for debugging.
  * `octave` is used for getting the coefficients of the filters (sorry).
* `just` is used as a command runner (try running `just` in various directories to see available commands)
* `prek`, `typstyle` and `cspell` are used for linting, on top of what the Rust toolchain provides.
* `usbutils`, `probe-rs-tools` and `dfu-util` are provided for interacting with the microcontrollers.
* `vmpk` is the MIDI keyboard used for testing, and `qpwgraph` is used for routing the audio source of Sparklet to the
  computer's speakers.
* `mdbook` is used for compiling this book.
* `typst`, `drawio`, `entr` and `python` are used for writing the thesis document.

## Adding support for a new device

For your board to be supported, it will need to be running an ARM Cortex M4 or M7 chip, with or without hardware float.
Ideally, you would have a debugger, be it a JLink or an ST-Link or just a STM32 Nucleo board, which includes an ST-Link
built-in for a mark-up.

For your board to be supported by Sparklet, `embassy_stm32` will need to have bindings for it. Look up it's CPU (which
should look something like `STM32F401RC`). On the black bar on the top of the <https://docs.embassy.dev/embassy-stm32/0.4.0>
website, you  will find a drop-down containing all the CPUs ("flavors") that are supported. Make sure your chip is
included.

Ideally, your board should also have a USB port built-in, or you will need to mount one yourself.

To support a new device, you will need to create a new feature, like so:

1. Add a new feature to `sparklet/runner/Cargo.toml`, that enables the respective feature in `embassy_stm32`.
2. Modify `Config.example.toml` to include the new hardware, commented out.
3. Modify `sparklet/runner/run-with-flags.sh` to specify the runner for your chip (particularly, change what model
   indicated to `probe-rs`).

You will to specify the new hardware layout in `sparklet/runner/src/hardware`:

1. Temporarily change the default features in `sparklet/runner/Cargo.toml` to use your chip, so the LSP works.
2. Copy an existing file for another device and rename it to the new devices' CPU's name, for each submodule.
3. Modify each submodule's `mod.rs` file so it reexports the new device's implementation if the chip is enabled.
4. Optionally, add compile-time assertions that fail if some of the features cannot work in the new device.
5. Check that every feature compiles and works properly.
