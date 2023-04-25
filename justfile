set shell := ["bash", "-uc"]
set dotenv-load
set positional-arguments


default:
  @just --list

startup:
  #!/usr/bin/env bash
  set -euxo pipefail
  time=`date +"%m_%d_%Y_%H:%M:%S"`
  mkdir -p $INCREMENT_DIR$time
  rsync -a $ORIGINAL_DIR $INCREMENT_DIR$time/$time
  echo $time > $FOLDER_KEY
  ls -t $INCREMENT_DIR | tail -n +6 | xargs -I{} rm -r $INCREMENT_DIR{}

increment:
  #!/usr/bin/env bash
  set -euxo pipefail
  time=`date +"%m_%d_%Y_%H:%M:%S"`
  folder=`cat $FOLDER_KEY`
  find $ORIGINAL_DIR -mmin -5.5 -exec rsync -z {} $INCREMENT_DIR$folder/$time/ \;

@rescue folder time:
  find $INCREMENT_DIR/$FOLDER ! -newermt "$TIME" -type f | sort -n | xargs -I{} rsync {} $RESCUE_DIR/
