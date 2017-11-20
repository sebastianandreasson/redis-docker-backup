#!/bin/bash

if [ -z "${CRON_TIME}" ]; then
    echo "You must supply a CRON_TIME environment variable" && exit 1
fi

echo "Starting script"

if [[ "$COMMAND" == restore ]]; then
    echo "Restoring backups"
    LATEST_RDB_NAME=$(ls -t ${BACKUP_RDB_DIR} | head -n1)
    LATEST_AOF_NAME=$(ls -t ${BACKUP_AOF_DIR} | head -n1)

    LATEST_RDB_PATH="${BACKUP_RDB_DIR}/${LATEST_RDB_NAME}"
    LATEST_AOF_PATH="${BACKUP_AOF_DIR}/${LATEST_AOF_NAME}"

    exec $(tar -xzf $LATEST_RDB_PATH && tar -xzf $LATEST_AOF_PATH)
elif [[ "$COMMAND" == backup ]]; then
    echo "Running backup script"
    echo "${CRON_TIME} /scripts/backup.sh $REDIS_RDB_PATH $BACKUP_RDB_DIR $REDIS_AOF_PATH $BACKUP_AOF_DIR $MAX_BACKUPS >> /log/redis_backup.log 2>&1" > /crontab.conf
    crontab  /crontab.conf
    echo "Running redis backups as a cron for ${CRON_TIME}"
    exec cron -f
fi
