#!/bin/bash

export $(grep -v '^#' ~/.gh_token | xargs -0)

#####################################################################
### Please set the paths accordingly. In case you don't have all  ###
### the listed folders, just keep that line commented out.        ###
#####################################################################
### Path to your config folder you want to backup
config_folder=~/klipper_config

### Path to your Klipper folder, by default that is '~/klipper'
klipper_folder=~/klipper

### Path to your Moonraker folder, by default that is '~/moonraker'
moonraker_folder=~/moonraker

### Path to your Mainsail folder, by default that is '~/mainsail'
mainsail_folder=~/mainsail

### Path to your klipper_logs folder, by default that is '~/klipper_logs'
klipper_logs_folder=~/klipper_logs

#####################################################################
#####################################################################


#####################################################################
################ !!! DO NOT EDIT BELOW THIS LINE !!! ################
#####################################################################
grab_version(){
  if [ ! -z "$klipper_folder" ]; then
    echo -n "Getting klipper version="
    cd "$klipper_folder"
    klipper_commit=$(git rev-parse --short=7 HEAD)
    m1="Klipper on commit: $klipper_commit"
    echo $klipper_commit
    cd ..
  fi
  if [ ! -z "$moonraker_folder" ]; then
    echo -n "Getting moonraker version="
    cd "$moonraker_folder"
    moonraker_commit=$(git rev-parse --short=7 HEAD)
    m2="Moonraker on commit: $moonraker_commit"
    echo $moonraker_commit
    cd ..
  fi
  if [ ! -z "$mainsail_folder" ]; then
    echo -n "Getting mainsail version="
    mainsail_ver=$(head -n 1 $mainsail_folder/.version)
    m3="Mainsail version: $mainsail_ver"
    echo $mainsail_ver
  fi
  if [ ! -z "$klipper_logs_folder" ]; then
    echo -n "Getting klipper_logs version="
    klipper_logs_ver=$(head -n 1 $klipper_logs_folder/.version)
    m4="klipper_logs version: $klipper_logs_ver"
    echo $klipper_logs_ver
  fi
}

push_config(){
  cd $config_folder
  echo Pushing updates
  git pull -v
  git add . -v
  current_date=$(date +"%Y-%m-%d %T")
  git commit -m "Backup triggered on $current_date" -m "$m1" -m "$m2" -m "$m3" -m "$m4"
#  git push "https://Artemis-CNC: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@github.com/Artemis-CNC/hevo-klipper-backup.git"
  git push "git@github.com:Artemis-CNC/hevo-klipper-backup.git"
}

grab_version
push_config