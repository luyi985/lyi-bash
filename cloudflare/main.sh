#!/bin/bash
source $(dirname "$0")/settings.sh

case "$system" in
	mac)
		source $(dirname "$0")/mac.sh
		;;
	ubuntu)
		source $(dirname "$0")/ubuntu.sh
		;;
	*)
		echo "Unsupported system: $system. Expected 'mac' or 'ubuntu'."
		return 1 2>/dev/null || exit 1
		;;
esac