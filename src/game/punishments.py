"""
Star Runner — Punishments Module
Handles long-term and temporary punishments
"""

# ------------------------------
# Example punishment types
# ------------------------------

PUNISHMENTS = {
    "name_flip": {"active": False, "timer": 0},
    "gender_swap": {"active": False, "timer": 0},
    "score_penalty": {"active": False, "timer": 0, "amount": 50},
}


# ------------------------------
# Apply punishment
# ------------------------------

def apply_punishment(state, profile, type_name):
    """Activate a punishment type."""
    if type_name in PUNISHMENTS:
        pun = PUNISHMENTS[type_name]
        pun["active"] = True
        pun["timer"] = 100  # example duration (frames)

        # Immediate effect example
        if type_name == "name_flip":
            profile["player_name"] = profile["player_name"][::-1]  # reverse name
        elif type_name == "gender_swap":
            if profile["player_gender"] == "male":
                profile["player_gender"] = "female"
            elif profile["player_gender"] == "female":
                profile["player_gender"] = "male"
        elif type_name == "score_penalty":
            state["score"] = max(0, state["score"] - pun["amount"])


# ------------------------------
# Update long-term punishments
# ------------------------------

def check_long_term_punishment(profile):
    """Decrement timers and remove expired punishments."""
    for pun in PUNISHMENTS.values():
        if pun["active"]:
            pun["timer"] -= 1
            if pun["timer"] <= 0:
                pun["active"] = False
