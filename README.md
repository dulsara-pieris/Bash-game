# 🚀 Star Runner

**Star Runner** is a fast-paced, terminal-based arcade game written entirely in **Shell script**. Navigate your starship through a dangerous asteroid field, collect power crystals, and utilize special abilities to achieve the highest score in the galaxy.

Developed by **Dulsara Pieris (SYNAPSNEX)**.

---

## 🕹️ Game Features

* **Dynamic Gameplay:** Dodge asteroids of various sizes that move across your terminal in real-time.
* **Career Profile System:** Automatically creates a persistent local profile (`~/.star_runner`) to track your name, age, high scores, total crystals, and career stats.
* **Combat Mechanics:** Use your onboard laser system to blast obstacles (requires ammo).
* **Power-ups:**

  * **☢ Shield:** Absorb a single hit without destroying your ship.
  * **◈ Super Mode:** Become invincible and destroy asteroids on contact.
  * **⊕ Ammo Pack:** Refill your laser reserves.
* **Ranking System:** Progress from a **Neural Trash** to a legendary **NEXUS-ZERO // 01101001** based on your mission performance.

---

## 🛠️ System Requirements

* Unix-like environment: **Linux**, **macOS**, or **WSL (Windows Subsystem for Linux)**.
* Standard utilities: `sh`, `stty`, `dd`, `od`.
* A terminal window sized at least **40 columns x 20 lines**.

---

## ⚡ Installation

Run the following command to install Star Runner:

```bash
curl -sSL https://raw.githubusercontent.com/dulsara-pieris/Bash-game/main/install.sh | sudo bash
```

This will:

* Copy `game.sh` to `/usr/local/bin/star-runner` (or a similar path).
* Set executable permissions.
* Optionally create a config/profile folder at `~/.star_runner`.

---

## 🎮 Controls

| Key        | Action                                |
| ---------- | ------------------------------------- |
| Arrow Keys | Navigate ship (Up, Down, Left, Right) |
| Spacebar   | Fire Laser (uses 1 ammo)              |
| Q          | Quit & Save Stats                     |

---

## 🏁 Quick Start

1. Open your terminal.
2. Run `star-runner` to start the game.
3. Dodge asteroids, collect crystals, and climb the ranks!
4. Quit with `Q` to save your progress.

> ⚠ Tip: Resize your terminal to **at least 40x20** for best gameplay experience.

---

## 🗑️ Uninstallation

To remove the game and your profile:

```bash
sudo ./uninstall.sh
rm -rf ~/.star_runner
```

---

## 📂 File Structure

```
├── AUTHORS.md
├── CODE_OF_CONDUCT.md
├── install.sh
├── LICENSE
├── NOTICE.md
├── README.md
├── src/
│   └── game.sh
├── uninstall.sh
└── VERSION
```

---

## 👥 Credits

* **Developer & Owner:** Dulsara Pieris (SYNAPSNEX)
* **Contributors:** See `AUTHORS.md`

---

## ⚖️ License

Star Runner is licensed under the **SYNAPSNEX OSS-Protection License (SOPL) v1.0**.
See [`LICENSE`](./LICENSE) and [`NOTICE.md`](./NOTICE.md) for details.

---

## 🔗 Links

* [Project Repository](https://github.com/dulsara-pieris/Bash-game)
* [Issues & Feedback](https://github.com/dulsara-pieris/Bash-game/issues)
