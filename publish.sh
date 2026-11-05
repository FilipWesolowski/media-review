#!/usr/bin/env bash
# Encrypts the v2 media review page and publishes it to GitHub Pages.
# Source: offer_api's git-ignored brainstorm folder. Only the encrypted index.html is committed.
set -euo pipefail
cd "$(dirname "$0")"
SRC=/Users/filip/Auroria/auroria_v3/apps/offer_api/docs/brainstorm/2026-11-03-v2-media-set/review.html
cp "$SRC" review.html
STATICRYPT_PASSWORD="$(cat .password)" npx --yes staticrypt@3.5.4 review.html -d encrypted \
  --remember 30 --template-title "v2 Media Review" --template-instructions "Auroria — v2 to v3 image migration review" \
  --template-color-primary "#3f4a5a" --template-color-secondary "#e9ebef"
mv encrypted/review.html index.html
rm -rf encrypted review.html
if grep -q 'res.cloudinary.com' index.html; then echo "plaintext leaked into index.html" >&2; exit 1; fi
git add index.html .staticrypt.json
git commit -m "Update review page" || echo "no changes"
git push
