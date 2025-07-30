#!/bin/bash

URL="https://nginxawsapp.icu"
LOG_DIR="/home/ec2-user/WVika/site_check_logs"
mkdir -p "$LOG_DIR"

DATE_TIME=$(date +"%Y.%m.%d_%H-%M")
TMP_LOG=$(mktemp)

STATUS_CODE=$(curl -s -w "\n%{http_code}" -D - "$URL" -o - | tee "$TMP_LOG" | tail -n1)
STATUS=$([[ "$STATUS_CODE" =~ ^2|3 ]] && echo "OK" || echo "ERROR")

LOG_FILE="$LOG_DIR/${DATE_TIME}_${STATUS}.log"

{
  echo "=== Check site $URL ==="
  echo "=== Time: ${DATE_TIME//_/' '} ==="
} > "$LOG_FILE"

rm "$TMP_LOG"