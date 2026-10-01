#!/usr/bin/env zsh

# Path to your repository
REPO_DIR=$(git rev-parse --show-toplevel)
cd "$REPO_DIR" || exit 1

# Detect active branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

# Exit immediately if branch does not start with "wip/"
if [[ "$CURRENT_BRANCH" != wip/* ]]; then
  exit 0
fi

# Stage and commit if there are uncommitted working tree changes
if [[ -n $(git status --porcelain) ]]; then
  git add -A
  git commit -m "auto WIP sync: $(date '+%Y-%m-%d %H:%M:%S')"
fi

# Pull remote changes for this WIP branch and push
git pull --rebase origin "$CURRENT_BRANCH" >/dev/null 2>&1
git push -u origin "$CURRENT_BRANCH" >/dev/null 2>&1
