#!/usr/bin/env bash
# Star Runner launcher (Python version)

# Ensure Python 3 is used
if ! command -v python3 &> /dev/null; then
    echo "Python3 is required to run Star Runner. Please install it."
    exit 1
fi

# Path to main.py
GAME_DIR="/usr/local/share/Star-runner/src"
MAIN_PY="$GAME_DIR/main.py"

if [ ! -f "$MAIN_PY" ]; then
    echo "Error: $MAIN_PY not found. Make sure Star Runner is installed correctly."
    exit 1
fi

# Launch the game
exec python3 "$MAIN_PY" "$@"
