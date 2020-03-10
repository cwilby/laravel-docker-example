#!/bin/bash

pushd /home/acme/acme/acme-rest-api
  /usr/bin/docker exec -t acme-production-workspace bash -i -c "sqldump"
  rsync -azP storage/* acme@backups.acme.net:acme/storage
  rsync -azP database/sql/db-backup*.sql acme@backups.acme.net:acme/sql
  scp ./.env acme@backups.acme.net:acme/.env
  ssh acme@backups.acme.net "find acme/sql -type f -mtime +7 -name '*.sql' -execdir rm -- '{}' +"
  rm -rf database/sql/db-backup*.sql
popd
