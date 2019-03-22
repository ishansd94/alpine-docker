#!/bin/sh
set -e

: ${SCRIPTS_DIR:=~/.scripts}

ls ${SCRIPTS_DIR}

for file in $(ls ${SCRIPTS_DIR} )
do
    source ${SCRIPTS_DIR}/$file
done

exec "$@"
