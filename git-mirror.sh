#!/bin/sh

set -e

SOURCE_REPO=$1
DESTINATION_REPO=$2
SOURCE_DIR=$(basename "$SOURCE_REPO" .git)
DRY_RUN=$3

GIT_SSH_COMMAND="ssh -v"

echo "SOURCE=$SOURCE_REPO"
echo "DESTINATION=$DESTINATION_REPO"
echo "DRY RUN=$DRY_RUN"

# 清理旧的目录（如果存在）
if [ -d "$SOURCE_DIR" ]; then
    echo "Cleaning up old directory..."
    rm -rf "$SOURCE_DIR"
fi

echo "Cloning source repository..."
if ! git clone --mirror "$SOURCE_REPO" "$SOURCE_DIR"; then
    echo "ERROR: Failed to clone source repository"
    exit 1
fi

cd "$SOURCE_DIR" || exit 1

echo "Setting up destination repository..."
git remote set-url --push origin "$DESTINATION_REPO"

echo "Fetching updates from source..."
if ! git fetch -p origin; then
    echo "ERROR: Failed to fetch updates from source"
    exit 1
fi

echo "Excluding pull request refs..."
git for-each-ref --format 'delete %(refname)' refs/pull | git update-ref --stdin

if [ "$DRY_RUN" = "true" ]; then
    echo "INFO: Dry Run, no data is pushed"
    if ! git push --mirror --dry-run; then
        echo "ERROR: Dry run push failed"
        exit 1
    fi
else
    echo "Pushing changes to destination..."
    if ! git push --mirror; then
        echo "ERROR: Failed to push changes to destination"
        exit 1
    fi
fi

echo "Sync completed successfully"

# 清理
cd ..
rm -rf "$SOURCE_DIR"
