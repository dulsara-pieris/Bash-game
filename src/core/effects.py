"""
Star Runner — Effects Module
Handles special effects like launch sequence
"""

from core.render import center_text, NUM_LINES

def launch_sequence():
    """Show launch banner in center of screen."""
    text = "▶ LAUNCHING STAR RUNNER ◀"
    center_text(text)
