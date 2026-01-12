"""
Star Runner — Player Profile Module
Handles saving, loading, and stats
"""

import json
import os
import hashlib
from core.config import PROFILE_FILE

# ------------------------------
# Default profile
# ------------------------------

DEFAULT_PROFILE = {
    "player_name": "Pilot",
    "player_title": "",
    "player_gender": "neutral",
    "player_birth_year": 2000,
    "high_score": 0,
    "crystals_bank": 0,
    "total_crystals": 0,
    "total_asteroids": 0,
    "current_ship": 0,
    "unlocked_ships": [0],
    "unlocked_skins": [],
}

# ------------------------------
# Helper: checksum
# ------------------------------

def compute_checksum(data: dict):
    """Return SHA256 checksum of profile JSON (stringified)."""
    json_str = json.dumps(data, sort_keys=True)
    return hashlib.sha256(json_str.encode("utf-8")).hexdigest()


# ------------------------------
# Profile operations
# ------------------------------

def init_profile():
    """Load existing profile or create default."""
    if os.path.exists(PROFILE_FILE):
        try:
            with open(PROFILE_FILE, "r") as f:
                profile_data = json.load(f)
            # Verify checksum if exists
            if "checksum" in profile_data:
                checksum = profile_data.pop("checksum")
                if compute_checksum(profile_data) != checksum:
                    print("⚠️ Profile tampering detected. Resetting profile.")
                    profile_data = DEFAULT_PROFILE.copy()
            else:
                profile_data = profile_data
        except Exception:
            print("⚠️ Failed to load profile. Creating new profile.")
            profile_data = DEFAULT_PROFILE.copy()
    else:
        profile_data = DEFAULT_PROFILE.copy()

    # Save immediately to ensure checksum
    save_profile(profile_data)
    return profile_data


def save_profile(profile: dict):
    """Save profile to disk with checksum."""
    data_copy = profile.copy()
    data_copy["checksum"] = compute_checksum(data_copy)
    try:
        with open(PROFILE_FILE, "w") as f:
            json.dump(data_copy, f, indent=4)
    except Exception as e:
        print(f"⚠️ Failed to save profile: {e}")
