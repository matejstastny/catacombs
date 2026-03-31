#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SPEC_FILE="$SCRIPT_DIR/SPEC.md"
TODO_FILE="$SCRIPT_DIR/TODO.todo"

# --- Usage ---
usage() {
    echo "Usage: $0 <language>"
    echo ""
    echo "Creates a new Catacombs project directory for the given language."
    echo ""
    echo "Examples:"
    echo "  $0 rust"
    echo "  $0 go"
    echo "  $0 kotlin"
    echo ""
    echo "Existing projects:"
    for dir in "$SCRIPT_DIR"/*/; do
        [ -d "$dir" ] && echo "  - $(basename "$dir")"
    done
    exit 1
}

# --- Validate ---
if [ $# -eq 0 ]; then
    usage
fi

LANG_NAME="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
PROJECT_DIR="$SCRIPT_DIR/$LANG_NAME"

if [ -d "$PROJECT_DIR" ]; then
    echo "Error: '$LANG_NAME' already exists at $PROJECT_DIR"
    echo ""
    read -rp "Open it in VS Code instead? (y/n) " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        code "$PROJECT_DIR"
    fi
    exit 1
fi

if [ ! -f "$SPEC_FILE" ]; then
    echo "Error: SPEC.md not found at $SPEC_FILE"
    exit 1
fi

if [ ! -f "$TODO_FILE" ]; then
    echo "Error: TODO.todo not found at $TODO_FILE"
    exit 1
fi

# --- Create project ---
TIMESTAMP="$(date '+%Y-%m-%d %H:%M')"
SPEC_VERSION="$(md5 -q "$SPEC_FILE" 2>/dev/null || md5sum "$SPEC_FILE" | cut -d' ' -f1)"

mkdir -p "$PROJECT_DIR"

# Copy SPEC.md with header
{
    echo "<!-- Created: $TIMESTAMP | Language: $LANG_NAME | Spec checksum: $SPEC_VERSION -->"
    echo ""
    cat "$SPEC_FILE"
} > "$PROJECT_DIR/SPEC.md"

# Copy TODO.todo with header
{
    echo "# Created: $TIMESTAMP | Language: $LANG_NAME"
    echo ""
    cat "$TODO_FILE"
} > "$PROJECT_DIR/TODO.todo"

# Create DEVLOG.md (recommended in the spec)
cat > "$PROJECT_DIR/DEVLOG.md" << EOF
# Catacombs — $LANG_NAME

Started: $TIMESTAMP

## What surprised me

## What was hard

## What's different from other languages I know
EOF

# --- Git setup (single repo at root) ---
if [ ! -d "$SCRIPT_DIR/.git" ]; then
    git init "$SCRIPT_DIR" --quiet
    echo "  Git:     initialized root repo"
fi

# Install prepare-commit-msg hook if missing
HOOK_FILE="$SCRIPT_DIR/.git/hooks/prepare-commit-msg"
if [ ! -f "$HOOK_FILE" ]; then
    cat > "$HOOK_FILE" << 'HOOKEOF'
#!/usr/bin/env bash
# Auto-prefix commit messages with the language directory name.
# e.g. "fix combat" → "rust: fix combat"
# Skips prefixing for merges, amends, and root-only changes.

COMMIT_MSG_FILE="$1"
COMMIT_SOURCE="${2:-}"

# Don't touch merges, squashes, or template commits
if [ "$COMMIT_SOURCE" = "merge" ] || [ "$COMMIT_SOURCE" = "squash" ]; then
    exit 0
fi

# Find which top-level directories have staged changes
REPO_ROOT="$(git rev-parse --show-toplevel)"
DIRS="$(git diff --cached --name-only | sed 's|/.*||' | sort -u)"

# Filter to only actual language project directories (have a SPEC.md)
LANG_DIRS=""
for d in $DIRS; do
    if [ -f "$REPO_ROOT/$d/SPEC.md" ]; then
        if [ -z "$LANG_DIRS" ]; then
            LANG_DIRS="$d"
        else
            LANG_DIRS="$LANG_DIRS,$d"
        fi
    fi
done

# Skip if no language dirs, or if message is already prefixed
if [ -z "$LANG_DIRS" ]; then
    exit 0
fi

CURRENT_MSG="$(cat "$COMMIT_MSG_FILE")"

# Don't double-prefix
if echo "$CURRENT_MSG" | head -1 | grep -qE '^[a-z,]+: '; then
    exit 0
fi

echo "$LANG_DIRS: $CURRENT_MSG" > "$COMMIT_MSG_FILE"
HOOKEOF
    chmod +x "$HOOK_FILE"
    echo "  Hook:    installed prepare-commit-msg"
fi

echo ""
echo "  Created: $PROJECT_DIR"
echo "  Files:   SPEC.md, TODO.todo, DEVLOG.md"
echo ""

# Open in VS Code
if command -v code &>/dev/null; then
    code "$PROJECT_DIR"
    echo "  Opened in VS Code."
else
    echo "  VS Code not found — open manually: $PROJECT_DIR"
fi
