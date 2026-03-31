<!-- Created: 2026-03-31 16:08 | Language: java | Spec checksum: 162bb0351d83ab02ecf9683913e02278 -->

# Catacombs — A Reusable Project Spec for Learning Any Language

A roguelike dungeon crawler built in 5 phases of increasing complexity. By the end you'll have touched every major feature area of the language: types, I/O, error handling, data structures, algorithms, networking, concurrency, and testing.

Pick a language. Start at Phase 1. Stop when you feel fluent.

---

## Phase 1 — The Game Loop

**Goal:** A playable single-floor dungeon in the terminal.

**Features:**
- Generate a rectangular dungeon map (rooms + corridors) using a simple grid
- Player `@` moves with WASD/arrow keys
- Fog of war — only reveal tiles within line-of-sight radius
- Spawn 3–5 enemies (`G`oblins, `S`keletons) with random placement
- Turn-based combat: bump into an enemy to attack, enemies move toward you each turn
- Player has HP, ATK, DEF stats; enemies have the same
- Die → game over screen with stats (kills, turns survived, damage dealt)
- Render the map to the terminal each turn (clear + redraw)

**What you'll learn:**
- Project setup, build tools, package manager
- Basic types, variables, constants
- Structs/classes/records (Player, Enemy, Tile, Map)
- Enums (TileType: Wall, Floor, Door; Direction: N/S/E/W)
- Collections (2D array for the map, list of enemies)
- Control flow (game loop, combat resolution, AI movement)
- Functions and modules (separate rendering, input, combat, map generation)
- Random number generation
- Terminal raw input (reading keypresses without Enter)

**Milestone:** You can walk around, kill goblins, and die. It's ugly but it works.

---

## Phase 2 — Persistence & Items

**Goal:** Save/load games, inventory system, multiple dungeon floors.

**Features:**
- Inventory system: pick up items (`!` potions, `/` swords, `]` armor, `?` scrolls)
- Items modify stats or have use-effects (heal, teleport, reveal map)
- Equip weapons/armor (weapon slot, armor slot, 10-slot backpack)
- Multiple floors: stairs `>` descend to a new procedurally generated level
- Enemies get harder per floor (scaling HP/ATK, new types: `O`gres, `D`ragons)
- Save game to a file (JSON or language-native serialization)
- Load game from file, resume exactly where you left off
- Config file for keybindings and preferences (read at startup)
- CLI arguments: `catacombs --new`, `catacombs --load save.json`, `catacombs --seed 42`

**What you'll learn:**
- File I/O (read/write)
- Serialization and deserialization (JSON, YAML, or binary)
- Error handling (corrupt save file, missing config, invalid input)
- CLI argument parsing (standard library or popular third-party lib)
- More complex data structures (inventory as a container, item inheritance/variants)
- Pattern matching / polymorphism (different item behaviors)
- Modules and project organization (splitting into multiple files/packages)

**Milestone:** You can save mid-run, quit, come back tomorrow, and keep exploring.

---

## Phase 3 — Procedural Generation & Algorithms

**Goal:** Interesting, varied dungeons with real algorithmic depth.

**Features:**
- Replace the simple grid with BSP (Binary Space Partitioning) dungeon generation
- Ensure connectivity: use graph traversal (BFS/DFS) to verify all rooms are reachable
- A* pathfinding for enemy AI (smarter enemies that navigate around walls)
- Loot tables with weighted random drops (common → legendary rarity)
- Field of view using raycasting or shadowcasting algorithm
- Mini-map showing explored areas
- Combat log: scrollable message history at the bottom of the screen
- Status effects: poison (DOT), stun (skip turn), haste (double move)

**What you'll learn:**
- Algorithms: BSP trees, BFS/DFS, A* pathfinding, raycasting
- Data structures: graphs, priority queues / heaps, trees, ring buffers (for log)
- Generics / templates (typed containers, generic loot table)
- Iterators / generators (lazy dungeon tile iteration)
- More advanced type system features (traits, interfaces, protocols, type classes)
- Performance basics (profiling the pathfinding, optimizing hot loops)

**Milestone:** Every floor feels different. Enemies intelligently hunt you. Loot is exciting.

---

## Phase 4 — Multiplayer & Networking

**Goal:** Online leaderboard and optional real-time co-op.

**Features:**

### 4A — Leaderboard API
- Build an HTTP REST API server:
  - `POST /runs` — submit a completed run (score, floors cleared, kills, cause of death)
  - `GET /leaderboard` — top 50 runs, sortable by score/floors/kills
  - `GET /leaderboard/{player}` — a specific player's history
- Client-side: after death, prompt "Submit score? (y/n)" → POST to the API
- Display the leaderboard from the main menu

### 4B — Co-op Mode (stretch goal)
- TCP or WebSocket server: host a game session
- Second player connects and joins the same dungeon
- Shared map, independent inventories, cooperative combat
- Turn order: both players submit moves, then all enemies move
- Handle disconnects gracefully (partner's character goes idle)

**What you'll learn:**
- HTTP server and client (routing, JSON request/response, status codes)
- TCP sockets or WebSocket protocol
- Concurrency primitives (threads, goroutines, async/await, actors — whatever the language offers)
- Synchronization (mutexes, channels, message passing — shared game state)
- Async I/O (non-blocking network + terminal input)
- Error handling over the network (timeouts, retries, malformed data)
- Basic security (input validation, rate limiting)

**Milestone:** You die on floor 7, submit your score, and see you're #14 on the global board. Or: you and a friend clear floor 10 together.

---

## Phase 5 — Polish & Engineering Practices

**Goal:** Production-quality code. Ship it.

**Features:**
- Unit tests for combat resolution, loot tables, pathfinding, serialization
- Integration tests for the API (spin up server, run requests, assert responses)
- Property-based / fuzz testing for dungeon generation (every generated map is solvable)
- CI pipeline (GitHub Actions or equivalent): lint, test, build on every push
- Structured logging (debug dungeon generation, trace enemy AI decisions)
- Documentation: README with build instructions, screenshots, architecture overview
- Package and distribute: publish a binary, Docker image, or package to a registry
- Optional: add a plugin/mod system — let users write custom items or enemies in the same language or via an embedded scripting language (Lua, Wasm)

**What you'll learn:**
- Testing frameworks and patterns (unit, integration, property-based)
- Mocking/stubbing (fake network, deterministic RNG for tests)
- Build systems and CI/CD
- Linting and formatting tools
- Logging libraries
- Packaging and distribution
- FFI or embedding (if you do the plugin system)

**Milestone:** `git push` triggers green CI. Someone can `brew install` / `cargo install` / `pip install` your game and play it.

---

## Quick Reference — Concepts by Phase

| Concept                        | Phase |
|--------------------------------|-------|
| Variables, types, control flow | 1     |
| Structs/classes, enums         | 1     |
| Collections, loops             | 1     |
| Functions, modules             | 1     |
| Random, terminal I/O           | 1     |
| File I/O, serialization        | 2     |
| Error handling                 | 2     |
| CLI parsing                    | 2     |
| Polymorphism / pattern match   | 2     |
| Algorithms (BFS, A*, BSP)      | 3     |
| Generics / templates           | 3     |
| Advanced data structures       | 3     |
| Performance / profiling        | 3     |
| HTTP server & client           | 4     |
| Concurrency & async            | 4     |
| Sockets / real-time networking | 4     |
| Synchronization primitives     | 4     |
| Testing (unit, integration)    | 5     |
| CI/CD, linting, packaging      | 5     |
| FFI / plugin system            | 5     |

---

## Tips

- **Don't over-design upfront.** Phase 1 code will get rewritten by Phase 3. That's the point — you learn refactoring too.
- **Use the standard library first.** Reach for third-party packages only when the stdlib genuinely doesn't have what you need.
- **Keep a `DEVLOG.md`.** Write down what surprised you, what was hard, what was different from languages you know. This is your real learning artifact.
- **Timebox each phase.** Aim for roughly a weekend per phase. If a phase takes much longer, that's signal about the language's learning curve in that area.
- **Compare across languages.** After doing this in 2+ languages, your devlogs become a powerful comparison of language ergonomics.
