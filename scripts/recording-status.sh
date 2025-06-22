#!/bin/bash

# Check if gpu-screen-recorder is running
if pgrep -f "gpu-screen-recorder" > /dev/null; then
    echo '{"text": "🔴 REC", "class": "recording", "tooltip": "Screen recording active"}'
else
    echo '{"text": "⚫", "class": "not-recording", "tooltip": "Not recording"}'
fi
