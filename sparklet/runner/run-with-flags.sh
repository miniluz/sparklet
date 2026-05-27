#!/usr/bin/env bash

if [ $# -eq 0 ]; then
   echo "Usage: $0 <command> [args...]" >&2
   exit 1
fi

# Read config data

model=$(tomlq '.chip.model' Config.toml)
model=${model#\"}; model=${model%\"}
midi=$(tomlq '.connections.midi' Config.toml)
audio=$(tomlq '.connections.audio' Config.toml)
equalizer=$(tomlq '.features["equalizer"]' Config.toml)
midi_config=$(tomlq '.features["midi-config"]' Config.toml)
peripheral_config=$(tomlq '.features["peripheral-config"]' Config.toml)


# Determine cargo config

case "$model" in
   stm32h723zg)
      target="thumbv7em-none-eabihf"
      cmd='rust-objcopy -O binary "$1" "$1.bin" && echo "$1.bin" && probe-rs run --chip STM32H723ZG --log-format "{t} {L} {s}" "$1"'
      runner="[\"sh\", \"-c\", '$cmd', \"_\"]"
      ;;
   stm32f401rc)
      target="thumbv7em-none-eabihf"
      cmd='rust-objcopy -O binary "$1" "$1.bin" && echo "$1.bin" && probe-rs run --chip STM32F401RC --log-format "{t} {L} {s}" "$1"'
      runner="[\"sh\", \"-c\", '$cmd', \"_\"]"
      ;;
   *)
      echo "Unknown model: $model" >&2
      exit 1
      ;;
esac


# Add feature flags

flags=(--no-default-features)

features=($model)
[ "$midi" = '"usb"' ] && features+=(midi-usb)
[ "$midi" = '"din"' ] && features+=(midi-din)
[ "$audio" = '"usb"' ] && features+=(audio-usb)
[ "$equalizer" = "true" ] && features+=(equalizer)
[ "$midi_config" = "true" ] && features+=(midi-config)
[ "$peripheral_config" = "true" ] && features+=(peripheral-config)

flags+=(--features "${features[*]}")

# Add config flags

flags+=(--config "build.target = \"$target\"")
flags+=(--config "target.$target.runner = $runner")


# Run

DEFMT_LOG="${DEFMT_LOG:-off}" exec "$@" "${flags[@]}"
