#!/usr/bin/env bash
set -euo pipefail

BUCKET=ci-cache-node-1720123456
OBJECT=test-9gb.bin
LOCAL_FILE=/tmp/$OBJECT
DOWNLOADED=/tmp/downloaded-$OBJECT

# 1. Generate a 9 GiB sparse file (fast) or full zeroed file (accurate disk I/O):
if ! [ -f "$LOCAL_FILE" ]; then
  echo "Generating 9 GiB test file…"
  # Sparse file (takes no actual disk space until written/read):
  truncate -s 9G "$LOCAL_FILE"
  # If you want to force real zeroes (slow):
  dd if=/dev/zero of="$LOCAL_FILE" bs=1M count=9216 status=progress
fi

# 2. Upload benchmark
echo "Uploading to gs://$BUCKET/$OBJECT…"
start=$(date +%s)
gsutil -o 'GSUtil:parallel_composite_upload_threshold=150M' cp "$LOCAL_FILE" gs://"$BUCKET"/"$OBJECT"
end=$(date +%s)
echo "Upload time: $((end - start)) seconds"

# 3. Download benchmark
echo "Downloading from gs://$BUCKET/$OBJECT…"
start=$(date +%s)
gsutil cp gs://"$BUCKET"/"$OBJECT" "$DOWNLOADED"
end=$(date +%s)
echo "Download time: $((end - start)) seconds"

gsutil ls -L gs://"$BUCKET"/test-9gb.bin


# 4. Cleanup (optional)
# rm -f "$LOCAL_FILE" "$DOWNLOADED"
