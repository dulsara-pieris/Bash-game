"""
Star Runner — Core Configuration
"""

import os
import shutil

# ------------------------------
# Terminal & Screen
# ------------------------------
TERMINAL_SIZE = shutil.get_terminal_size(fallback=(80, 24))
NUM_COLUMNS, NUM_LINES = TERMINAL_SIZE.columns, TERMINAL_SIZE.lines

# Game timing
TURN_DURATION = 0.05  # seconds per frame

# ------------------------------
# Colors (ANSI escape codes)
# ------------------------------
COLOR_NEUTRAL = "\033[0m"
COLOR_CYAN = "\033[36m"
COLOR_GREEN = "\033[32m"
COLOR_RED = "\033[31m"
COLOR_YELLOW = "\033[33m"
COLOR_MAGENTA = "\033[35m"
COLOR_BLUE = "\033[34m"
COLOR_WHITE = "\033[37m"

# ------------------------------
# Game constants
# ------------------------------
NUM_LINES = max(NUM_LINES, 20)
NUM_COLUMNS = max(NUM_COLUMNS, 40)

NUM_ASTEROIDS = 100
NUM_CRYSTALS = 50
NUM_POWERUPS = 20

# ------------------------------
# Ships & Weapons
# ------------------------------
DEFAULT_AMMO = 10
DEFAULT_SHIP = 0

# ------------------------------
# Files
# ------------------------------
PROFILE_FILE = os.path.expanduser("~/.star_runner_profile.json")
