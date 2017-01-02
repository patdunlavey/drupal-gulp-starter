#!/bin/bash

set -e

path=$(dirname "$0")
base=$(cd $path/.. && pwd)
drush="$base/bin/drush $drush_flags -y -r $base/www"

# Get Pantheon's Command Line Tool, terminus.
sudo curl https://github.com/pantheon-systems/terminus/releases/download/0.13.5/terminus.phar -L -o /usr/local/bin/terminus
sudo chmod +x /usr/local/bin/terminus
