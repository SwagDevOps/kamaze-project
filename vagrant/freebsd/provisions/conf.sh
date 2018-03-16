#/usr/bin/env sh

set -e

STORAGE_DIR=/tmp/conf

test -d "${STORAGE_DIR}" || exit 0
chmod +x "${STORAGE_DIR}/"*
mv "${STORAGE_DIR}/"* /usr/local/bin
rm -rf "${STORAGE_DIR}"
