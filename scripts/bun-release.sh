#!/bin/bash
set -e


# Usage: ./release.sh <target-folder> [patch|minor|major] [--dry-run] [--no-bump]
# Default bump type: patch

TARGET_DIR=""
BUMP_TYPE="patch"
DRY_RUN="false"
NO_BUMP="false"

# Parse args
for arg in "$@"; do
  case "$arg" in
    --dry-run)
      DRY_RUN="true"
      ;;
    --no-bump)
      NO_BUMP="true"
      ;;
    patch|minor|major)
      BUMP_TYPE="$arg"
      ;;
    *)
      if [[ -z "$TARGET_DIR" ]]; then
        TARGET_DIR="$arg"
      fi
      ;;
  esac
done

if [ -z "$TARGET_DIR" ]; then
  echo "Error: Target directory required as first argument."
  exit 1
fi

# Ensure jq is installed
if ! command -v jq &> /dev/null; then
  echo "Error: jq is required. Install with 'sudo apt-get install jq'"
  exit 1
fi

ORIG_DIR="$(pwd)"
cd "$TARGET_DIR"

PKG_FILE="package.json"

if [[ "$NO_BUMP" == "true" ]]; then
  # Use current version from package.json without bumping
  CUR_VERSION=$(jq -r .version "$PKG_FILE")
  NEW_VERSION="$CUR_VERSION"
else
  # Get current version and calculate new version
  CUR_VERSION=$(jq -r .version "$PKG_FILE")
  IFS='.' read -r MAJOR MINOR PATCH <<< "$CUR_VERSION"

  case "$BUMP_TYPE" in
    major)
      MAJOR=$((MAJOR+1))
      MINOR=0
      PATCH=0
      ;;
    minor)
      MINOR=$((MINOR+1))
      PATCH=0
      ;;
    patch)
      PATCH=$((PATCH+1))
      ;;
    *)
      echo "Unknown bump type: $BUMP_TYPE. Use patch, minor, or major."
      cd "$ORIG_DIR"
      exit 1
      ;;
  esac

  NEW_VERSION="$MAJOR.$MINOR.$PATCH"
fi


# --dry-run option: print the next version and exit
if [[ "$DRY_RUN" == "true" ]]; then
  echo "$NEW_VERSION"
  cd "$ORIG_DIR"
  exit 0
fi

if [[ "$NO_BUMP" == "true" ]]; then
  # Skip package.json update, just tag and push
  git tag "v$NEW_VERSION"
  git push --tags
  echo "Tagged current version v$NEW_VERSION and pushed tags (no version bump)."
else
  # Update package.json, commit, tag, and push
  jq ".version = \"$NEW_VERSION\"" "$PKG_FILE" > "$PKG_FILE.tmp" && mv "$PKG_FILE.tmp" "$PKG_FILE"
  
  git add "$PKG_FILE"
  git commit -m "chore: bump version to v$NEW_VERSION"
  git tag "v$NEW_VERSION"
  git push
  git push --tags
  
  echo "Version bumped to $NEW_VERSION, committed, tagged, and pushed."
fi

cd "$ORIG_DIR"
