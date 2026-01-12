"""
Star Runner — Ships Module
Handles ship stats, ammo, and selection
"""

# ------------------------------
# Ship definitions
# ------------------------------

SHIPS = [
    {
        "name": "Falcon",
        "ammo": 10,
        "speed": 1,
        "shield": False
    },
    {
        "name": "Eagle",
        "ammo": 15,
        "speed": 2,
        "shield": True
    },
    {
        "name": "Hawk",
        "ammo": 8,
        "speed": 3,
        "shield": False
    }
]

# ------------------------------
# Helper functions
# ------------------------------

def get_ship_ammo(ship_index: int) -> int:
    """Return the ammo for the selected ship."""
    if 0 <= ship_index < len(SHIPS):
        return SHIPS[ship_index]["ammo"]
    return 10  # default ammo


def get_ship_name(ship_index: int) -> str:
    """Return the name of the selected ship."""
    if 0 <= ship_index < len(SHIPS):
        return SHIPS[ship_index]["name"]
    return "Unknown"


def get_ship_speed(ship_index: int) -> int:
    """Return speed of the ship."""
    if 0 <= ship_index < len(SHIPS):
        return SHIPS[ship_index]["speed"]
    return 1


def ship_has_shield(ship_index: int) -> bool:
    """Return True if ship has built-in shield."""
    if 0 <= ship_index < len(SHIPS):
        return SHIPS[ship_index]["shield"]
    return False
