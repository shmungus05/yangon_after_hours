# Yangon After Hours (ရန်ကုန်ညဉ့်နက်ချိန်)

A 2D point-and-click pixel-art mystery puzzle adventure set in the rain-slicked streets, tea shops, and night markets of Yangon, Myanmar. Built with **Godot 4.x** and **GDScript**, designed for desktop and mobile touch input, targeting web and HTML5 export.

---

## 🌃 Overview

Explore Yangon under the neon glow of street signs and golden pagoda reflections:
- **Interactive City Map**: Navigate between Downtown (Sule), Lucky Tea Shop (38th Street), and the Night Market (Strand Road Waterfront).
- **Point-and-Click Interaction System**: Inspect hotspots, investigate curious artifacts, and speak with local residents.
- **Character Dialogue & Outlined Avatars**: Multi-page dialogue system featuring 16-bit pixel portraits with transparent cutouts and crisp outlines.
- **Investigator's Notebook**: Cross-location clue tracking that records discoveries and puzzle evidence.
- **Burmese Tea Shop Puzzle**: Deduce and serve the exact traditional tea orders (`Cho-seint`, `Cho-pyit`, `Pawt-seint`) for Saya Min (Teacher), Ma Thida (Trader), and Ko Aung (Taxi Driver) using dialogue clues.

---

## 👥 Characters & Cast

- **Tea Master Ko Zaw** — Lucky Tea Shop counter master.
- **Night Watchman U Ba** — Sentry guarding colonial banks near Sule Pagoda.
- **Street Food Cook Ko Lin** — Sizzling grill vendor at Strand Road Night Market.
- **Saya Min (The Teacher)** — Grading exams late into the night, needs strong tea (`Cho-pyit`).
- **Ma Thida (The Trader)** — Haggling all day at the harbor, craves sweet and rich tea (`Cho-seint`).
- **Ko Aung (The Driver)** — Midnight taxi driver, prefers low-sugar, extra creamy brew (`Pawt-seint`).

---

## 🛠️ Project Structure

```text
yangon-after-hours/
├── assets/
│   ├── avatars/             # Character portrait sprites (transparent PNG with outlines)
│   ├── locations/           # Location backgrounds (Downtown, Tea Shop, Market)
│   └── map/                 # Stylized Yangon city map
├── scenes/
│   ├── main_menu.tscn       # Main title screen with Play button
│   ├── city_map.tscn        # City navigation map
│   ├── location_screen.tscn # Base location screen
│   ├── components/
│   │   ├── dialogue_panel.tscn    # Reusable dialogue box with avatar frame
│   │   ├── notebook_panel.tscn    # Investigator's clue notebook UI
│   │   └── tea_puzzle_panel.tscn  # Interactive Burmese tea matching puzzle
│   └── locations/
│       ├── downtown.tscn    # Downtown Sule scene
│       ├── tea_shop.tscn    # Lucky Tea Shop scene & puzzle trigger
│       └── market.tscn      # Strand Road Night Market scene
└── scripts/
    ├── game_state.gd        # Autoload singleton (clues, puzzles, navigation)
    ├── interactable_hotspot.gd # Hotspot button component
    ├── dialogue_panel.gd    # Dialogue controller
    ├── notebook_panel.gd    # Notebook UI controller
    ├── tea_puzzle_panel.gd  # Tea puzzle controller
    └── test_*.gd            # Headless automated test suites
```

---

## 🚀 Running the Game

1. Download or clone this repository.
2. Open **Godot Engine 4.x** (v4.2+ recommended).
3. Import the project using `project.godot`.
4. Press **F5** (or click **Play**) to start from `res://scenes/main_menu.tscn`.

### Controls
- **Mouse / Touch**: Tap or click hotspots, map pins, and notebook buttons.
- **Space / Enter**: Advance dialogue.
- **Escape**: Close dialogue, notebook, or puzzle panels.

---

## 🧪 Automated Tests

Run the test suite headless with the Godot executable:

```powershell
godot --headless -s "res://scripts/test_avatars.gd"
godot --headless -s "res://scripts/test_tea_puzzle.gd"
godot --headless -s "res://scripts/test_clue_system.gd"
godot --headless -s "res://scripts/test_interactions.gd"
```
