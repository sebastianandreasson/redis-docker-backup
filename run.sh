#!/bin/bash

echo "Running backup script"
echo "${CRON_TIME} /scripts/backup.sh $BACKUP_DIR $REDIS_HOST $MAX_BACKUPS >> /log/redis_backup.log 2>&1" > /crontab.conf
crontab /crontab.conf
echo "Running redis backups as a cron for ${CRON_TIME}"
exec cron -f
