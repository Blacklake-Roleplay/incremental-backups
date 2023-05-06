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
  cpz $ORIGINAL_DIR $INCREMENT_DIR$time/$time
  echo $time > $FOLDER_KEY
  ls -t $INCREMENT_DIR | tail -n +10 | xargs -I{} rm -r $INCREMENT_DIR{}

increment:
  #!/usr/bin/env bash
  set -euxo pipefail
  time=`date +"%m_%d_%Y_%H:%M:%S"`
  folder=`cat $FOLDER_KEY`
  cd $ORIGINAL_DIR && fdfind --changed-within "6m" --no-ignore -x cpz {} $INCREMENT_DIR$folder/$time/{}


@rescue folder time:
  find $INCREMENT_DIR/{{folder}} ! -newermt "{{time}}" -type f | sort -n | xargs -I{} rsync {} $RESCUE_DIR/

# fdfind --changed-before "2023-05-05 13:56:00" --no-ignore . ./increments/05_05_2023_11:30:59 | sort -n
@fast folder time:
  fdfind --changed-before "{{time}}" --no-ignore . $INCREMENT_DIR/{{folder}} | sort -S 5% --parallel=4 -n | xargs -I {} cpz {} $RESCUE_DIR/
