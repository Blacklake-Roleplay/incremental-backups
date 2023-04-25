set shell := ["bash", "-uc"]
set dotenv-load
set positional-arguments


default:
  @just --list

startup:
  #!/usr/bin/env bash
  set -euxo pipefail
  time=`date +"%m_%d_%Y_%H:%M:%S"`
  mkdir -p {{increment_dir}}$time
  rsync -a {{original_dir}} {{increment_dir}}$time/$time
  echo $time > {{folder_key}}
  ls -t {{increment_dir}} | tail -n +6 | xargs -I{} rm -r {{increment_dir}}{}

increment:
  #!/usr/bin/env bash
  set -euxo pipefail
  time=`date +"%m_%d_%Y_%H:%M:%S"`
  folder=`cat {{folder_key}}`
  find {{original_dir}} -mmin -5.5 -exec rsync -z {} {{increment_dir}}$folder/$time/ \;

@rescue folder time:
  find {{increment_dir}}/{{folder}} ! -newermt "{{time}}" -type f | sort -n | xargs -I{} rsync {} {{rescue_dir}}/
