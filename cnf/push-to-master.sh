#!/bin/bash
#
# push-to-master.sh
#
# This script will push all of the generated build results of a CI
# server to a downstream repository.
#
# Variables:
#
#   DOWNSTREAM: The URL of the downstream repository.
#   BRANCH:     The branch to push to - optional, defaults to master.
#   CLONE_DIR:  The directory to clone the downstream to - optional.
#   MESSAGE:    The commit message - optional.
set -e

DOWNSTREAM=ssh://codeserver.dev.0cf7dc21-c128-433e-a2b1-ba6a9bbc820f@codeserver.dev.0cf7dc21-c128-433e-a2b1-ba6a9bbc820f.drush.in:2222/~/repository.git
BRANCH=master

SELF_DIR="`dirname -- "$0"`"
DRUPAL_ROOT="`dirname -- "$SELF_DIR"`"
CLONE_DIR="${CLONE_DIR:-$DRUPAL_ROOT/artifacts/clone}"
MESSAGE="${MESSAGE:-Updating downstream repository}"
mkdir -p $CLONE_DIR

if [ -z "$BRANCH" ]; then
  echo "\$BRANCH not set - exiting"
  exit 1
fi
git check-ref-format --branch $BRANCH

if [ -z "$DOWNSTREAM" ]; then
  echo "\$DOWNSTREAM not set - exiting"
  exit 1
fi

echo "Beginning build of $BRANCH in $CLONE_DIR to $DOWNSTREAM"

# Try a clone directly to the right branch if possible.  If the branch
# doesn't exist yet, check out to the default branch and create it.
git clone --depth 1 -b "$BRANCH" "$DOWNSTREAM" "$CLONE_DIR" || git clone --depth 1 "$DOWNSTREAM" "$CLONE_DIR"
pushd $CLONE_DIR
  git checkout -B "$BRANCH"
popd

# Sync everything but .git/ and artifacts/ to the downstream folder.
# .gitignore will take over from there.
rsync -a --delete --exclude=artifacts/ --exclude=.git/ --exclude=node_modules --exclude=bower_components $DRUPAL_ROOT $CLONE_DIR

pushd $CLONE_DIR
  #mv .artifact.gitignore .gitignore
  # Remove any newly excluded files.
  git ls-files -z --ignored --exclude-standard | xargs -0 -r git rm -r --cached --ignore-unmatch
  git add .
  git commit -m "$MESSAGE"
  git remote add pantheon ssh://codeserver.dev.0cf7dc21-c128-433e-a2b1-ba6a9bbc820f@codeserver.dev.0cf7dc21-c128-433e-a2b1-ba6a9bbc820f.drush.in:2222/~/repository.git
  git push pantheon "$BRANCH"
popd

echo "Push completed - cleaning up $CLONE_DIR"
rm -rf $CLONE_DIR
