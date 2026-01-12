"""
Star Runner — Utility Functions
"""

import sys
import time
from core.config import COLOR_NEUTRAL, NUM_COLUMNS, NUM_LINES


# ------------------------------
# Terminal Helpers
# ------------------------------

def clear_screen():
    """Clear terminal screen."""
    sys.stdout.write("\033[2J\033[H")
    sys.stdout.flush()


def move_cursor(line: int, col: int):
    """Move cursor to specific terminal position (1-indexed)."""
    sys.stdout.write(f"\033[{line};{col}H")
    sys.stdout.flush()


def center_text(text: str, line: int = None):
    """Print text centered horizontally (and optionally vertically)."""
    col = max(1, (NUM_COLUMNS - len(text)) // 2 + 1)
    if line is None:
        # Default: center vertically
        line = NUM_LINES // 2
    move_cursor(line, col)
    print(text, end="", flush=True)


def sleep_safe(seconds: float):
    """Sleep without interruption affecting terminal."""
    try:
        time.sleep(seconds)
    except KeyboardInterrupt:
        pass


# ------------------------------
# Colors
# ------------------------------

def colored(text: str, color_code: str):
    """Return colored text."""
    return f"{color_code}{text}{COLOR_NEUTRAL}"


# ------------------------------
# Misc Helpers
# ------------------------------

def clamp(value, min_value, max_value):
    """Clamp a value between min and max."""
    return max(min_value, min(max_value, value))


def increment_frame(frame: int):
    """Increment frame counter safely."""
    return frame + 1


def debug(*args):
    """Print debug info to stderr."""
    print("[DEBUG]", *args, file=sys.stderr)
