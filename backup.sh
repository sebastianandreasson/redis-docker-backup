#!/bin/bash

REDIS_RDB_PATH=$1
BACKUP_RDB_DIR=$2
REDIS_AOF_PATH=$3
BACKUP_AOF_DIR=$4
MAX_BACKUPS=$5

if [ -z "$MAX_BACKUPS" ]; then
    MAX_BACKUPS=10
fi

echo "Cleaning up old backups"

while [ $(ls -N1 ${BACKUP_RDB_DIR} | wc -l) -gt ${MAX_BACKUPS} ];
do
    BACKUP_TO_BE_DELETED=$(ls -N1 ${BACKUP_RDB_DIR} | sort | head -n 1)
    echo "Backup $BACKUP_TO_BE_DELETED is deleted"
    rm "$BACKUP_RDB_DIR/$BACKUP_TO_BE_DELETED"
done

while [ $(ls -N1 ${BACKUP_AOF_DIR} | wc -l) -gt ${MAX_BACKUPS} ];
do
    BACKUP_TO_BE_DELETED=$(ls -N1 ${BACKUP_AOF_DIR} | sort | head -n 1)
    echo "Backup $BACKUP_TO_BE_DELETED is deleted"
    rm "$BACKUP_AOF_DIR/$BACKUP_TO_BE_DELETED"
done

echo "Creating backups"

CURRENT_DATE=$(date +\%Y_\%m_\%d_\%H_\%M_\%S)
BACKUP_RDB_NAME="redis_rdb_$CURRENT_DATE.tar.gz"
BACKUP_AOF_NAME="redis_aof_$CURRENT_DATE.tar.gz"

BACKUP_RDB_PATH="${BACKUP_RDB_DIR}/${BACKUP_RDB_NAME}"
BACKUP_AOF_PATH="${BACKUP_AOF_DIR}/${BACKUP_AOF_NAME}"

tar -czf $BACKUP_RDB_PATH $REDIS_RDB_PATH
tar -czf $BACKUP_AOF_PATH $REDIS_AOF_PATH