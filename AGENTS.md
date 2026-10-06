# AGENTS.md

## Project: Shallow-Water-Godot

A 2D platformer/game in Godot 4.7 (Forward Plus, GL compatibility renderer).

## Shell

**Fish shell** (`fish`) is used for all terminal commands.

## Naming Conventions

### Characters
{entity}_{animation}.png          → soldier_idle.png
{entity}_{part}_{animation}.png   → soldier_spear.png
{entity}_{variant}.png            → purson_b.png
{npc}_{action}.png                → lost_child_look_left.png

### UI
{category}_{element}.png          → buttons_plate.png
{overlay}_{bar}_{state}.png       → hp_blue.png
{item}_{type}.png                 → hp_potion.png

### World
{type}_{variant}.png              → pillar_base.png
{type}_{direction}.png            → lever_b.png (back)
{type}_{state}.png                → lever_f.png (front)

### Tiles
{area}_{type}_{index}.png         → dungeon_floor_01.png
{area}_{type}_{variant}.png       → dungeon_wall_corner.png

## Directory Structure

```
project/
├── scenes/                    ← ALL scene files (.tscn)
│   ├── core/
│   │   └── main_game.tscn     ← main scene (project.godot entry point)
│   ├── levels/
│   │   ├── test_level_01.tscn
│   │   ├── boss_arena.tscn
│   │   └── start_area.tscn
│   ├── entities/
│   │   ├── player.tscn
│   │   ├── soldier.tscn
│   │   └── water_crab.tscn
│   ├── props/
│   │   ├── static/            ← StaticBody2D props (walls, pillars, crates)
│   │   ├── interactive/       ← Interactable props (levers, chests, doors)
│   │   └── decorative/        ← Sprite2D props (chains, lanterns, signs)
│   ├── ui/                    ← HUD, menus, overlays
│   └── shared/
│       ├── collision_shapes/
│       └── markers/
├── res/                       ← reusable .tres resources
│   └── tilesets/
├── src/                       ← CODE ONLY (no .tscn or .tres)
│   ├── core/main_game/
│   │   └── main_game.gd
│   ├── gameplay/
│   │   ├── enemies/
│   │   │   ├── Enemy.gd       ← base enemy class
│   │   │   ├── Flip_ray.gd
│   │   │   ├── states/        ← AI state machine
│   │   │   │   ├── StateMachineBase.gd
│   │   │   │   ├── Chase.gd
│   │   │   │   └── Patrol.gd
│   │   │   ├── soldier/
│   │   │   └── water_crab/
│   │   ├── player/
│   │   │   ├── player.gd
│   │   │   ├── combat_controller.gd
│   │   │   ├── health_controller.gd
│   │   │   ├── movement_controller.gd
│   │   │   └── weapon_sprite.gd
│   │   ├── camera/
│   │   └── interactables/
│   │       └── interactable.gd
│   ├── levels/
│   │   ├── base_level.gd      ← abstract base level class
│   │   └── test_level_01/
│   ├── resources/             ← .tres data files only (enemy stats, items, etc.)
│   ├── props/                 ← map prop base classes
│   │   ├── prop_base.gd
│   │   ├── static_prop.gd
│   │   └── decorative_prop.gd
│   ├── tiles/                 ← tile support
│   │   ├── tile_data.gd
│   │   └── tileset_manager.gd
│   ├── shaders/
│   └── ui/
└── assets/
    └── art/
        ├── characters/
        │   ├── player/          ← idle, walk, jump, dash, attack, water_attack
        │   ├── enemies/         ← soldier, water_crab, statue_boss
        │   └── npcs/            ← lost_child, merchant, purson, fallen_soldier
        ├── ui/
        │   ├── buttons/         ← plate, a, b, x, y, menu, tab
        │   ├── d-pad/           ← up, down, left, right
        │   ├── triggers/        ← lb, lt, rb, rt
        │   ├── icons/           ← health, mana, roman_numbers, mask
        │   ├── overlays/        ← hp, mana, energy, shell
        │   ├── shop/            ← background, coins, potions, items
        │   └── name_plate.png
        └── world/
            ├── backgrounds/     ← far/, mid/, near/ (depth layers)
            ├── tiles/           ← dungeon/ (tileset sheets)
            └── props/
                ├── static/      ← non-interactive (walls, pillars, crates)
                ├── interactive/ ← levers, doors
                ├── decorative/  ← chains, lanterns, signs, dead bodies, story
                └── one_off/     ← unique scene elements
        └── icon.png
```

## Key Conventions

### Separation of Concerns
- **`scenes/`** — scene files only (.tscn). Compositions, layouts, data.
- **`src/`** — code only (.gd). Logic, behavior, classes.
- **`res/`** — reusable data resources (.tres). Config, tilesets, stats.
- **`assets/`** — imported files (images, audio, fonts).

### Naming
- Scenes and scripts share the same base name: `scenes/entities/player.tscn` ↔ `src/gameplay/player/player.gd`
- Godot auto-generates `.uid` files alongside scripts — do not edit them manually.

### Physics Layers (2D)
| Layer | Name   | Used For              |
|-------|--------|-----------------------|
| 1     | Player | Player character      |
| 2     | Ground | Floor tiles           |
| 3     | Enemy  | Enemies               |
| 4     | Wall   | StaticBody2D walls    |

### Render Layers (2D)
| Layer | Name       | Used For               |
|-------|------------|------------------------|
| 1     | Forground  | Floor, foreground      |
| 2     | Object     | Static props           |
| 3     | Entity     | Player, enemies        |
| 4     | Background | Background layers      |

### Scene Organization
- **TileMapLayer** — floors, walls, repeating surfaces (use layers 2/4)
- **StaticBody2D** — one-off physical props (pillars, crates)
- **CollisionShape2D + Sprite2D** — decorations with no collision (chains, lanterns)

## Known Issues
- `soldier.tscn` and `water_crab.tscn` have broken script paths referencing old `res://Scripts/...` paths. Open in Godot editor and re-link scripts.

## Fish Shell Tips
- Use `fish` syntax for any shell commands in this project.
- No `&&` chaining issues — fish handles them fine.
- Tab completion works as expected.
