#!/bin/bash

POOL_NAME=other    ## 这里 other 改成资源池名称即可；例如：jiangsu03
PULL_FILE=rsync_yum.sh
RSYNC_SCRIPTS=/tmp/rsync_yum.sh
TSA='124.236.120.248'

## rsync pass file
echo "RSYNC_BACKUP_PASSWD" >/etc/rsync.password
chmod 600 /etc/rsync.password

rsync --partial -avzuP rsync_backup@${TSA}::yum_rsync/script/${PULL_FILE:-noneaaa} ${RSYNC_SCRIPTS} --password-file=/etc/rsync.password
PULL_STATE=$(echo $?)
if [ ${PULL_STATE} -eq 0 ]; then
    flock -xn /var/run/rsync_yum.lock -c "/bin/sh ${RSYNC_SCRIPTS} ${POOL_NAME}"
else
    rsync --partial -avzuP rsync_backup@${TSA}::yum_rsync/script/${PULL_FILE:-noneaaa} ${RSYNC_SCRIPTS} --password-file=/etc/rsync.password
    PULL_STATE=$(echo $?)
    if [ ${PULL_STATE} -eq 0 ]; then
        flock -xn /var/run/rsync_yum.lock -c "/bin/sh ${RSYNC_SCRIPTS} ${POOL_NAME}"
    else
        echo "fail  $(date +%F' '%T) $(hostname)"  >${POOL_NAME}.yum_rsync.info
        rsync --delete -avz ${POOL_NAME}.yum_rsync.info rsync_backup@124.236.120.248::yum_rsync --password-file=/etc/rsync.password
    fi
fi

rm -f ${RSYNC_SCRIPTS} 2>/dev/null
