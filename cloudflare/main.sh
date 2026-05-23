#!/bin/bash
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

source "$script_dir/settings.sh"

case "$system" in
	mac)
		source "$script_dir/mac.sh"
		;;
	ubuntu)
		source "$script_dir/ubuntu.sh"
		;;
	*)
		echo "Unsupported system: $system. Expected 'mac' or 'ubuntu'."
		return 1 2>/dev/null || exit 1
		;;
esac