# Installation

## Prerequisites

You probably want to install this on a Linux system. Windows _should_ work too, but it's untested. Particularly,
since Nix is Linux-only and used to get the rest of the packages at specific versions, you might struggle. However
[WSL](https://learn.microsoft.com/en-us/windows/wsl/install) might work. Make an issue and we can try to figure it out!

As prerequisites, you will need to:

- Install [Git](https://git-scm.com/install/).
- [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
  the [Sparklet repository](https://github.com/miniluz/sparklet).
- Install [Nix](https://nixos.org/download/) (pick the multi-user installation if you have no preference).
- If in Linux, add `probe-rs`'s [udev rules](https://probe.rs/docs/getting-started/probe-setup/#linux-udev-rules).
- Have an STM32 board. To see the boards Sparklet currently supports, check the `[features]` section of
  [`sparklet/runner/Cargo.toml`](https://github.com/miniluz/sparklet/blob/main/sparklet/runner/Cargo.toml).

### Other boards

If you want to use another board, you will need to do some development work. I am willing to help with this.
If you don't feel up to the task, open an issue and I'll try to help!

However, do read the beginning of the "Adding support for a new device" section of the
[development section](./03_Development.md), just to make sure that your board _can_ be supported.




## Installation

### Prepare the configuration

At the root of the repository you cloned, you will want to run `nix-shell -A "devShells.x86_64-linux.user"`. This will
provide a shell with the software you will need to compile Sparklet. If using a shell that isn't Bash, you might need
[any-nix-shell](https://github.com/haslersn/any-nix-shell). If you open a new shell, you will need to run it again.

Once it's done, you will prepare the configuration like so:

```bash
# Move to the runner folder
cd sparklet/runner/

# Copy the Config.example.toml
cp Config.example.toml Config.toml

# Edit the Config.toml
nano Config.toml
```

When editing the configuration, make sure to set the board model to whichever one you own. The simplest way to use
Sparklet is by using USB for audio and MIDI, in which case you may just plug it into your computer and play.

### Plug in your board

Plug in your board through USB. If you have a development board (with a JLink or ST-Link), check that `probe-rs` can
find it:

```bash
probe-rs list
```

If you don't, you need to look up how to activate DFU mode. Normally this is done plugging it in while
holding the `BOOT0` button down. It should then show up when running:

```bash
dfu-util -l
```

In either case, if it isn't showing up, try running the commands as `sudo`:

```bash
sudo probe-rs list
# or
sudo dfu-util -l
```

If they show up _then_, you're probably missing `udev` rules that allow your user to control the USB ports directly.
You might still get things working by running the rest of the needed commands as `sudo` (e.g. `sudo command`), but I'd
recommend adding the rules.

### Compile and write the software

Finally, run:

```bash
./run-with-flags.sh cargo run --release

# If you want logging (Only through ST-Link or JLink)
DEFMT_LOG=error ./run-with-flags.sh cargo run --release
# or
DEFMT_LOG=info ./run-with-flags.sh cargo run --release
```

If you own a development board, `probe-rs` should run the program.

If you don't, you will need to manually install the firmware. Look up the offset at which code begins in memory
for your board (probably `0x08000000`) and run:

```bash
# CHANGE THE OFFSET AS APPROPRIATE
#                vvvvvvvvvv
dfu-util -a 0 -s 0x08000000:leave -D ../target/thumbv7em-none-eabihf/release/runner.bin`
#                                              ^^^^^^^^^^^^^^^^^^^^^
# You might also need to change the architecture
```

### Connect the synthesizer

Connect the device through USB to the computer, either through the USB port linked to the board if using, say, a Nucleo,
or by disconnecting and reconnecting the board without holding the `BOOT0` if using a non-development board. Sparklet
should show up as an audio source and MIDI sink. You may route MIDI to it and use it as an input in your DAW of choice.
