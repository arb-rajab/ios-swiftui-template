#!/usr/bin/env bash
# Rename the template to your app. Run once, from the repo root, before the first commit.
#
#   ./rename.sh <BundleId> "<Display Name>"
#   ./rename.sh com.acme.myapp "My App"
#
# The Swift module/type prefix is the display name without spaces ("MyApp"), so the display name
# must contain only letters, digits and spaces. The lowercase prefix used for Keychain/UserDefaults
# keys is the bundle id's last component.
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <bundle.id> \"<Display Name>\"" >&2
  exit 1
fi
BUNDLE_ID="$1"; NAME="$2"
CLASS="${NAME// /}"
SLUG="${BUNDLE_ID##*.}"
PREFIX="${BUNDLE_ID%.*}"

[[ "$BUNDLE_ID" =~ ^[A-Za-z][A-Za-z0-9-]*(\.[A-Za-z][A-Za-z0-9-]*)+$ ]] || { echo "invalid bundle id" >&2; exit 1; }
[[ "$CLASS" =~ ^[A-Za-z][A-Za-z0-9]*$ ]] || { echo "display name must be letters, digits and spaces" >&2; exit 1; }
[[ "$SLUG" =~ ^[a-z][a-z0-9]*$ ]] || { echo "last bundle id component must be lowercase letters/digits" >&2; exit 1; }

# Order matters: the bundle id and display name both contain the type-prefix token.
FILES=$(grep -rlE 'com\.example\.starterapp|bundleIdPrefix: com\.example|Starter App|StarterApp|starterapp' . \
  --exclude-dir=.git --exclude-dir=build --exclude-dir=DerivedData --exclude=rename.sh || true)
for f in $FILES; do
  sed -i \
    -e "s|bundleIdPrefix: com\.example|bundleIdPrefix: ${PREFIX}|" \
    -e "s|com\.example\.starterapp|${BUNDLE_ID}|g" \
    -e "s|Starter App|${NAME}|g" \
    -e "s|StarterApp|${CLASS}|g" \
    -e "s|starterapp|${SLUG}|g" "$f"
done

# Rename directories and files whose names carry the token (deepest first).
for p in $(find Sources Tests -depth -name '*StarterApp*'); do
  mv "$p" "$(dirname "$p")/$(basename "$p" | sed "s|StarterApp|${CLASS}|g")"
done

echo "Renamed to ${NAME} (${BUNDLE_ID}). Then run (on macOS): brew install xcodegen && xcodegen generate"
echo "Fill in LICENSE ([YEAR] [COPYRIGHT HOLDER]) and delete this script when done."
