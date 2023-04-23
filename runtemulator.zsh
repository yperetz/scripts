#!/bin/bash

terminator_process_id=$(pidof -x terminator)
if [[ -z $terminator_process_id ]]; then
    /bin/terminator
else
    wmctrl -a Terminator
fi
