# XP & Level-Up System — Assignment

When this is done, every kill fills an XP bar. Each level-up pauses the game and shows 3 cards; each card is either a new augment or +1 level on one you already have.

- **Start of a run:** the player owns one augment (Scythe Throw), not all of them.
- **The hook already exists:** `enemy.gd` announces every death to the `kill_listeners` group by calling `react_to_kill`. The new LevelSystem joins that group, the same way VampyricSuck does.
- **Budget:** about 6 hours. Tasks 1–8 are logic; Task 9 is the popup UI and can be built in parallel once the interface below is agreed.

```
enemy dies ──► LevelSystem.react_to_kill ──► xp += xp_value ──► xp >= xp_to_next?
                                                                  │ no → emit xp_changed, done
                                                                  ▼ yes
                              pause game ──► emit level_up_ready(choices) ──► popup shows 3 cards
                                                                                     │ click
                              unpause ◄── add new augment / level_up() ◄── pick(choice)
```

---

## Interface contract

The UI never touches augments directly: it only listens to two signals on LevelSystem and calls one function. Agree on these names first, and the logic and the popup can be built by different people at the same time.

LevelSystem is a `Node` under `World`, in the group `"level_system"` so the UI can find it with `get_tree().get_first_node_in_group("level_system")`.

| Member | Kind | Who uses it | What it means |
| --- | --- | --- | --- |
| `xp_changed(xp, xp_to_next, level)` | signal | XP bar | Fired on every XP gain and level-up; redraw the bar |
| `level_up_ready(choices)` | signal | Popup | The game is paused; show one card per choice |
| `pick(choice)` | function | Popup | Call when a card is clicked; applies it and unpauses |

Each choice is a Dictionary, so the popup can draw a card without knowing anything else:

| Key | Type | Example |
| --- | --- | --- |
| `id` | String | `"burn"` |
| `title` | String | `"Burning Effect"` |
| `description` | String | `"Hits can set enemies on fire"` |
| `is_new` | bool | `true` = not owned yet; `false` = level-up |
| `level` | int | The level it becomes if picked (1 for new) |

Test the popup before the logic exists: emit `level_up_ready` yourself with two or three hand-written dictionaries.

---

## Tasks

Do them in order; each ends with a check you can see in the game. Commit after each one.

### Task 1 — XP value on enemies (10 min)

- [ ] Add `@export var xp_value: float = 1` to `enemy.gd`.
- [ ] Set it higher on the Brute in `brute_enemy.tscn` (try 3).

**Done when:** the Brute shows the new value in the inspector.

### Task 2 — LevelSystem: XP and levels (45 min)

- [ ] Create `scripts/level_system.gd` and attach it to a new `Node` named `LevelSystem` under `World`.
- [ ] Variables: `xp`, `level` (start at 1), `xp_to_next`.
- [ ] Declare both signals from the interface contract.
- [ ] Join `"kill_listeners"` and `"level_system"` in `_ready`.
- [ ] In `react_to_kill(enemy)`: add the enemy's `xp_value`, then level up while `xp >= xp_to_next`.
- [ ] Leveling up: subtract `xp_to_next` from `xp`, add 1 to `level`, then raise `xp_to_next`.
- [ ] Emit `xp_changed` at the end of `react_to_kill`.

**Hint:** a simple curve is `xp_to_next = 5 + level * 3`. Use `while`, not `if`, so one big kill can give two levels.

**Done when:** `print` shows the level going up as you kill enemies.

### Task 3 — XP bar (30 min)

- [ ] Add a `ProgressBar` to `ui.tscn`, under the health bar.
- [ ] In `ui.gd`, find LevelSystem and connect `xp_changed`; set `max_value` to `xp_to_next` and `value` to `xp`.

**Done when:** the bar fills on kills and empties on level-up.

### Task 4 — Augment catalog (45 min)

One list that holds every augment the game can offer.

- [ ] Make every augment a scene. In `player.tscn`, right-click each augment node → *Save Branch as Scene* → `scenes/augments/`. (Scythe Throw, Corpse Explosion and Sun Beam already are.)
- [ ] In `level_system.gd`, add an array of dictionaries: one per augment with `id`, `title`, `description`, `scene` (a `preload` of its `.tscn`) and `max_level` (try 5).
- [ ] Add `var owned: Dictionary = {}` mapping `id` → the augment node on the player.

**Done when:** the catalog lists every augment in the [Augment levels](#augment-levels) table.

### Task 5 — Starting loadout (15 min)

- [ ] Delete every augment node from `player.tscn` except Scythe Throw (and VampyricSuck from `world.tscn` if it is still there).
- [ ] In LevelSystem's `_ready`, record Scythe Throw in `owned` so it can be leveled.

**Done when:** a new run has only the thrown scythe.

### Task 6 — Building the choices (45 min)

- [ ] Write `_make_choices() -> Array` that returns up to 3 choice dictionaries (shape in the interface contract).
- [ ] Skip anything owned at `max_level`.
- [ ] Owned → `is_new = false`, `level` = its level + 1. Not owned → `is_new = true`, `level = 1`.
- [ ] Randomize: copy the catalog, `shuffle()` it, take the first 3 that pass.

**Done when:** printing `_make_choices()` five times gives different, valid sets.

### Task 7 — Level-up flow and pick (45 min)

- [ ] On level-up: `get_tree().paused = true`, then emit `level_up_ready(_make_choices())`.
- [ ] Write `pick(choice)`: if `is_new`, instantiate the scene, `add_child` it to the player and store it in `owned`; otherwise call `level_up()` on the owned node.
- [ ] End `pick` with `get_tree().paused = false`.
- [ ] If there are no choices left (everything maxed), skip the popup and heal the player instead.

**Done when:** calling `pick` with a hand-made choice adds or levels an augment.

### Task 8 — Augment levels (1 h)

- [ ] Give every augment `var level: int = 1` and a `level_up()` that adds 1 and improves its numbers (see the table below).
- [ ] For the three on-hit effects, put `level_up()` in each child script, not in `OnHitEffect`: each improves different numbers.

**Done when:** picking the same augment twice makes it visibly stronger.

### Task 9 — Popup UI (1.5 h)

- [ ] Build a popup scene under the `CanvasLayer`: a dimmed background and a row of 3 buttons (or panels) for cards.
- [ ] Set the popup's *Process → Mode* to **Always** (see Gotchas).
- [ ] On `level_up_ready`: show the popup and fill one card per choice with `title`, `description` and "NEW" or "Lv N".
- [ ] On card press: call `pick(choice)` and hide the popup.

**Done when:** a full loop works — kill, level up, pick, keep playing.

---

## Augment levels

Suggested numbers for each `level_up()`, applied once per level; tune them after playtesting. Max level 5 for all.

| Augment | Script | Each level |
| --- | --- | --- |
| Scythe Throw | `scythe_throw_augment.gd` | `damage` ×1.25, `cooldown` ×0.85 |
| Corpse Explosion | `corpse_explosion.gd` | `explosion_damage` ×1.25, `explosion_radius` +20, `cooldown` ×0.85 |
| Sun Beam Blast | `sun_beam_blast_augment.gd` | `cooldown` ×0.85 (its damage lives on the beam scene, `sun_beam_blast.gd`) |
| Vampyric Suck | `vampyric_suck.gd` | `heal_per_kill` +0.5 |
| Stun | `stun_on_hit.gd` | `proc_chance` +0.05, `stun_duration` +0.25 |
| Burning Effect | `burn_on_hit.gd` | `proc_chance` +0.05, `burn_damage_per_second` +3 |
| Slow | `slow_on_hit.gd` | `proc_chance` +0.05, `slow_factor` ×0.85 (lower = slower) |
| High Noon | `high_noon.gd` | `duration` +1, `cooldown` ×0.9 |

Multiplying (×0.85) never reaches zero, so cooldowns shrink but never break; subtracting from a cooldown could.

---

## Gotchas

- **Pausing freezes the popup too.** `get_tree().paused = true` stops every node, including your buttons. Set the popup's *Process → Mode* to **Always** in the inspector; its children inherit it.
- **`create_timer` keeps running while paused.** By default it ignores pause, so High Noon's buff (and other `await`ed timers) tick down while the popup is open. Pass `false` as the second argument: `create_timer(duration, false)`.
- **One kill can give two levels.** Use `while` when checking XP, and don't open a second popup while one is showing. Queue the extra level-up and show it after `pick`.
- **Picking an owned augment must not add a second copy.** Always check `owned` first; two Stun nodes would each roll separately.
- **A new augment starts its cooldown when added.** `_ready` runs at `add_child`, so a freshly picked augment waits one full cooldown before it fires. Set its `_timer` lower if that feels slow.
- **`preload` paths break when files move.** If you rename or move an augment scene, update its catalog entry.

## Testing checklist

- [ ] Kill enemies: the XP bar fills and resets on level-up.
- [ ] Level-up pauses enemies and the player; the popup still responds to clicks.
- [ ] A NEW card adds the augment; it starts working after its cooldown.
- [ ] Picking the same augment again shows "Lv 2" and it gets stronger.
- [ ] A maxed augment never appears as a card.
- [ ] High Noon's buff doesn't run out while the popup is open.
- [ ] Set `xp_value` to 100 on enemies: multiple level-ups in a row each get their own popup.

---

## Stretch goals (only if time allows)

- **XP orbs:** enemies drop a pickup instead of giving XP instantly; orbs drift toward the player when close.
- **Reroll button:** one free reroll per level-up that calls `_make_choices()` again.
- **Card icons:** add an `icon` texture to each catalog entry and show it on the card.
- **Owned augments HUD:** a small row of icons with their levels in a corner of the screen.
