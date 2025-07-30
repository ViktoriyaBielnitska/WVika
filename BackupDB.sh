#!/bin/bash

DB_NAME="flaskdb"
DB_USER="flaskuser"
BACKUP_DIR="/home/ec2-user/WVika/db_backups"
LOG_DIR="/home/ec2-user/WVika/db_backup_logs"
PGPASSWORD="flaskpass"

mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"

DATE_TIME=$(date +"%Y.%m.%d_%H-%M")
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${DATE_TIME}.sql"
LOG_FILE="${LOG_DIR}/${DATE_TIME}.log"

docker exec -e PGPASSWORD=$PGPASSWORD db \
  pg_dump -U "$DB_USER" "$DB_NAME" > "$BACKUP_FILE" 2> /tmp/pg_backup_error.log

STATUS=$([[ $? -eq 0 ]] && echo "OK" || echo "ERROR")

{
  echo "Backup of $DB_NAME"
  echo "Time: ${DATE_TIME//_/' '}"
  if [[ "$STATUS" == "OK" ]]; then
    echo "Backup successful: $BACKUP_FILE"
  else
    echo "Backup failed. Check error log at /tmp/pg_backup_error.log"
  fi
} > "$LOG_FILE"
