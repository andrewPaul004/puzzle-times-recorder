#!/usr/bin/env bash
# BMad branch automation hook
# Fires after every Write tool call.
# - Story file created  → creates epic branch (if new) + story branch
# - Retro file created  → prints reminder to merge epic → main manually

INPUT=$(cat)

# Extract file_path from JSON (handles "file_path":"val" and "file_path": "val")
FILE_PATH=$(printf '%s' "$INPUT" | grep -o '"file_path" *: *"[^"]*"' | sed 's|"file_path" *: *"\(.*\)"|\1|' | head -1)

[ -z "$FILE_PATH" ] && exit 0

# Normalize Windows backslashes to forward slashes
FILE_PATH="${FILE_PATH//\\//}"

BASENAME=$(basename "$FILE_PATH")

# Only act on files inside implementation-artifacts/
echo "$FILE_PATH" | grep -q "_bmad-output/implementation-artifacts/" || exit 0

# ─── STORY FILE: N-M-name.md ────────────────────────────────────────────────
# Matches "1-2-user-auth.md" but not "epic-1-retro-2026-04-25.md"
if echo "$BASENAME" | grep -qE '^[0-9]+-[0-9]+-[^/]+\.md$' && ! echo "$BASENAME" | grep -qE '^epic-'; then

    EPIC_NUM=$(echo "$BASENAME" | sed 's/^\([0-9]*\)-.*/\1/')
    STORY_NUM=$(echo "$BASENAME" | sed 's/^[0-9]*-\([0-9]*\)-.*/\1/')
    STORY_NAME=$(echo "$BASENAME" | sed 's/^[0-9]*-[0-9]*-\(.*\)\.md$/\1/')

    STORY_BRANCH="story/${EPIC_NUM}.${STORY_NUM}-${STORY_NAME}"

    # Skip if story branch already exists (e.g. hook fired on a file update)
    if git branch --list "$STORY_BRANCH" 2>/dev/null | grep -q .; then
        exit 0
    fi

    # Find existing epic/N-* branch
    EPIC_BRANCH=$(git branch --list "epic/${EPIC_NUM}-*" 2>/dev/null | head -1 | tr -d ' *')

    if [ -z "$EPIC_BRANCH" ]; then
        # Derive epic name slug from epics.md heading
        EPIC_HEADING=$(grep -m1 "^## Epic ${EPIC_NUM}:" "_bmad-output/planning-artifacts/epics.md" 2>/dev/null || true)
        if [ -n "$EPIC_HEADING" ]; then
            EPIC_NAME=$(echo "$EPIC_HEADING" \
                | sed "s/^## Epic ${EPIC_NUM}: *//" \
                | tr '[:upper:]' '[:lower:]' \
                | tr -cs 'a-z0-9' '-' \
                | sed 's/-*$//' \
                | cut -c1-40)
        else
            EPIC_NAME="epic-${EPIC_NUM}"
        fi
        EPIC_BRANCH="epic/${EPIC_NUM}-${EPIC_NAME}"

        echo ""
        echo "🌿 Creating epic branch: $EPIC_BRANCH (from main)"
        git checkout main 2>&1 || { echo "⚠️  Could not checkout main — commit or stash changes first"; exit 1; }
        git checkout -b "$EPIC_BRANCH" 2>&1
        git push -u origin "$EPIC_BRANCH" 2>/dev/null \
            && echo "✅ Epic branch pushed to origin" \
            || echo "⚠️  Could not push to remote — run: git push -u origin $EPIC_BRANCH"
    fi

    echo ""
    echo "🌿 Creating story branch: $STORY_BRANCH (from $EPIC_BRANCH)"
    git checkout "$EPIC_BRANCH" 2>&1
    git checkout -b "$STORY_BRANCH" 2>&1
    echo "✅ Now on branch: $STORY_BRANCH"
    echo ""
    echo "  When the story is done and tests pass, merge back:"
    echo "    git checkout $EPIC_BRANCH"
    echo "    git merge $STORY_BRANCH"
    echo "    git push origin $EPIC_BRANCH"
    echo "    git branch -d $STORY_BRANCH"
    echo "    git push origin --delete $STORY_BRANCH"
    echo ""

    exit 0
fi

# ─── RETRO FILE: epic-N-retro-*.md ──────────────────────────────────────────
if echo "$BASENAME" | grep -qE '^epic-[0-9]+-retro-.*\.md$'; then

    EPIC_NUM=$(echo "$BASENAME" | sed 's/^epic-\([0-9]*\)-.*/\1/')
    EPIC_BRANCH=$(git branch --list "epic/${EPIC_NUM}-*" 2>/dev/null | head -1 | tr -d ' *')

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  📋 RETROSPECTIVE COMPLETE — Epic ${EPIC_NUM}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "  Run all checks first:"
    echo "    npm run type-check && npm run test && npm run test:a11y && npm run test:e2e"
    echo ""
    echo "  Then merge epic to main:"
    echo "    git checkout main && git pull origin main"
    echo "    git merge ${EPIC_BRANCH:-epic/${EPIC_NUM}-???}"
    echo "    git push origin main"
    echo "    git branch -d ${EPIC_BRANCH:-epic/${EPIC_NUM}-???}"
    echo "    git push origin --delete ${EPIC_BRANCH:-epic/${EPIC_NUM}-???}"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    exit 0
fi

exit 0
