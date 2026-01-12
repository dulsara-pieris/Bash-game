"""
Star Runner — Input Handling
Non-blocking keypresses for terminal
"""

import sys
import tty
import termios
import select

# Key mapping
KEY_UP = "w"
KEY_DOWN = "s"
KEY_LEFT = "a"
KEY_RIGHT = "d"
KEY_PAUSE = "p"
KEY_QUIT = "q"
KEY_FIRE = " "  # space

# ------------------------------
# Terminal Input
# ------------------------------

class KeyListener:
    """Non-blocking key listener for Unix terminals."""

    def __enter__(self):
        self.fd = sys.stdin.fileno()
        self.old_settings = termios.tcgetattr(self.fd)
        tty.setcbreak(self.fd)  # set terminal to cbreak mode
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        termios.tcsetattr(self.fd, termios.TCSADRAIN, self.old_settings)

    def get_key(self):
        """Return pressed key as string, or None if no key pressed."""
        dr, _, _ = select.select([sys.stdin], [], [], 0)
        if dr:
            return sys.stdin.read(1)
        return None


# ------------------------------
# Game Input Handling
# ------------------------------

def handle_input(state):
    """Update game state based on pressed keys."""
    key = handle_input.listener.get_key()
    if key is None:
        return

    # Quit
    if key == KEY_QUIT:
        from core.utils import clear_screen
        clear_screen()
        print("Exiting Star Runner...")
        import sys
        sys.exit(0)

    # Pause toggle
    if key == KEY_PAUSE:
        state["paused"] = not state["paused"]

    # Movement
    if key == KEY_UP:
        state["ship_line"] = max(1, state["ship_line"] - 1)
    elif key == KEY_DOWN:
        state["ship_line"] = min(state["ship_line"] + 1,  NUM_LINES)
    elif key == KEY_LEFT:
        state["ship_column"] = max(1, state["ship_column"] - 1)
    elif key == KEY_RIGHT:
        state["ship_column"] = min(state["ship_column"] + 1, NUM_COLUMNS)

    # Fire
    if key == KEY_FIRE:
        state["laser_active"] = True  # will be handled in weapons module


# Initialize single listener instance
handle_input.listener = KeyListener()
handle_input.listener.__enter__()
