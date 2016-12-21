#!/bin/bash

set -e

path=$(dirname "$0")
base=$(cd $path/.. && pwd)
drush="$base/bin/drush $drush_flags -y -r $base/www"

#terminus --site=edc-hv-impact --env=dev site backups get --element=db --latest --file=mydb.sql
