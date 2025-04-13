#!/bin/bash

# Default to 'terminator' if TEMULATOR is not set
emulator="${TEMULATOR:-terminator}"

# Get the process ID(s) of the emulator
emulator_process_id=$(pidof -x "$emulator")

if [[ -z $emulator_process_id ]]; then
    # if not running, start it
    "$emulator" &
else
    wmctrl -a "$emulator"
fi
