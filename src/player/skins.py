"""
Star Runner — Skins Module
Handles cosmetic skins for ships
"""

# ------------------------------
# Skin Definitions
# ------------------------------

SKINS = [
    {
        "name": "Classic",
        "color": "Cyan",
        "unlocked": True
    },
    {
        "name": "Red Comet",
        "color": "Red",
        "unlocked": False
    },
    {
        "name": "Golden Star",
        "color": "Yellow",
        "unlocked": False
    },
    {
        "name": "Shadow",
        "color": "Magenta",
        "unlocked": False
    }
]

# ------------------------------
# Skin Functions
# ------------------------------

def get_skin(index: int):
    """Return skin data for a given index."""
    if 0 <= index < len(SKINS):
        return SKINS[index]
    return SKINS[0]  # default


def unlock_skin(profile: dict, skin_index: int):
    """Unlock a skin for the player."""
    if 0 <= skin_index < len(SKINS):
        if skin_index not in profile.get("unlocked_skins", []):
            profile.setdefault("unlocked_skins", []).append(skin_index)
            print(f"🎉 Skin '{SKINS[skin_index]['name']}' unlocked!")


def is_skin_unlocked(profile: dict, skin_index: int) -> bool:
    """Check if skin is unlocked in profile."""
    return skin_index in profile.get("unlocked_skins", [])
