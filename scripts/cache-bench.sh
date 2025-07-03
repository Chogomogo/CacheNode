#!/usr/bin/env bash
set -euo pipefail

#Directory to hold the test data (default: cache-data)

DIR=${1:-cache-data}
FILE="$DIR/test-9gb.bin"

#Create directory if it doesn't exist
mkdir -p "$DIR"
#Generate a sparse 9 GiB file (very fast; consumes no actual disk space until read)
truncate -s 9G "$FILE"
echo "Generated sparse file: $FILE (size: $(du -h "$FILE" | awk '{print $1}'))"