#!/bin/bash
# This script install additional dependencies
# for the v-core 3 klipper setup.

source /home/pi/klipper_config/config/scripts/ratos-common.sh

verify_ready()
{
    if [ "$EUID" -eq 0 ]; then
        echo "This script must not run as root"
        exit -1
    fi
}

symlink_extensions()
{
	report_status "Symlinking klippy extensions"
	symlink_result=$(curl --fail --silent -X POST 'http://localhost:3000/configure/api/trpc/klippy-extensions.symlink' -H 'content-type: application/json')
	configurator_success=$?
	if [ $configurator_success -eq 0 ]
	then
		echo $symlink_result | jq -r '.result.data.json'
	else
		echo "Failed to symlink extensions. Is the RatOS configurator running?"
		exit 1
	fi
}

# Force script to exit if an error occurs
set -e

verify_ready
symlink_extensions