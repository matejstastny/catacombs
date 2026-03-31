# Catacombs

A roguelike dungeon crawler project designed to be rebuilt in every new language you learn.

One spec, one checklist, many languages. Each implementation lives in its own directory and progresses through 5 phases — from a basic game loop to a multiplayer server with CI/CD.

## Getting started

```bash
./init.sh <language>
```

This creates a new directory with:
- `SPEC.md` — the full project spec
- `TODO.todo` — checkable task list
- `DEVLOG.md` — your notes on what surprised you, what was hard, what was different

## Structure

```
.
├── init.sh          # scaffold a new language project
├── SPEC.md          # master spec (source of truth)
├── TODO.todo        # master task list (source of truth)
├── rust/            # one dir per language
├── go/
└── ...
```

## Phases

1. **The Game Loop** — types, structs, enums, terminal I/O, turn-based combat
2. **Persistence & Items** — file I/O, JSON, error handling, CLI args, inventory
3. **Procedural Generation** — BSP, A*, shadowcasting, generics, performance
4. **Multiplayer & Networking** — REST API, WebSockets, concurrency, async
5. **Polish & Engineering** — testing, CI/CD, packaging, plugin system

See [SPEC.md](SPEC.md) for the full breakdown.

## License

[MIT](LICENSE)
