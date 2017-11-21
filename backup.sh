#!/bin/bash

BACKUP_DIR=$1
REDIS_HOST=$2
MAX_BACKUPS=$3

echo "Cleaning up old backups"

while [ $(ls -N1 ${BACKUP_DIR} | wc -l) -ge ${MAX_BACKUPS} ];
do
    BACKUP_TO_BE_DELETED=$(ls -N1 ${BACKUP_DIR} | sort | head -n 1)
    echo "Backup $BACKUP_TO_BE_DELETED is deleted"
    rm "$BACKUP_DIR/$BACKUP_TO_BE_DELETED"
done

echo "Creating backups"

CURRENT_DATE=$(date +\%Y_\%m_\%d_\%H_\%M)
BACKUP_NAME="redis_rdb_$CURRENT_DATE"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_NAME}"

redis-cli -h $REDIS_HOST --rdb "$BACKUP_PATH.rdb"
tar -czf "$BACKUP_PATH.tar.gz" "$BACKUP_PATH.rdb"
rm "$BACKUP_PATH.rdb"
