"""
Star Runner — Menu Module
Handles main menu, ship selection, and help
"""

from core.utils import center_text, move_cursor, colored
from player.ships import SHIPS, get_ship_name
from player.skins import SKINS, get_skin
from core.config import NUM_LINES, NUM_COLUMNS, COLOR_CYAN, COLOR_NEUTRAL
import sys

# ------------------------------
# Main Menu
# ------------------------------

def show_main_menu(profile):
    """Display main menu and handle user choice."""
    center_text("☆ STAR RUNNER ☆", NUM_LINES // 2 - 4)
    center_text("1. Start Game", NUM_LINES // 2 - 2)
    center_text("2. Select Ship", NUM_LINES // 2 - 1)
    center_text("3. Help", NUM_LINES // 2)
    center_text("4. Quit", NUM_LINES // 2 + 1)
    
    choice = input("\nSelect option (1-4): ").strip()
    
    if choice == "1":
        return  # Start game
    elif choice == "2":
        select_ship(profile)
    elif choice == "3":
        show_help()
        show_main_menu(profile)
    elif choice == "4":
        print("Exiting Star Runner...")
        sys.exit(0)
    else:
        print("Invalid choice.")
        show_main_menu(profile)


# ------------------------------
# Ship Selection
# ------------------------------

def select_ship(profile):
    """Allow player to select unlocked ship."""
    print("\nAvailable Ships:")
    for idx, ship in enumerate(SHIPS):
        unlocked = idx in profile.get("unlocked_ships", [])
        status = "(Unlocked)" if unlocked else "(Locked)"
        print(f"{idx}. {ship['name']} {status}")
    
    choice = input("Select ship index: ").strip()
    if choice.isdigit():
        idx = int(choice)
        if idx in profile.get("unlocked_ships", []):
            profile["current_ship"] = idx
            print(f"Selected ship: {SHIPS[idx]['name']}")
        else:
            print("Ship locked.")
    else:
        print("Invalid input.")


# ------------------------------
# Help Screen
# ------------------------------

def show_help():
    """Display help instructions."""
    print("\n--- HELP ---")
    print("W/A/S/D : Move ship")
    print("SPACE   : Fire laser")
    print("P       : Pause")
    print("Q       : Quit game")
    print("Collect crystals and destroy asteroids to score points!")
    input("\nPress Enter to return to menu...")
