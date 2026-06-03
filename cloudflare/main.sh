#!/bin/bash
if [ -n "$BASH_SOURCE" ]; then
	cloudflare_script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
elif [ -n "$ZSH_VERSION" ]; then
	cloudflare_script_dir=$(cd -- "$(dirname -- "${(%):-%x}")" &> /dev/null && pwd)
else
	cloudflare_script_dir=$(cd -- "$(dirname -- "$0")" &> /dev/null && pwd)
fi

source "$cloudflare_script_dir/settings.sh"

case "$system" in
	mac)
		source "$cloudflare_script_dir/mac.sh"
		;;
	ubuntu)
		source "$cloudflare_script_dir/ubuntu.sh"
		;;
	*)
		echo "Unsupported system: $system. Expected 'mac' or 'ubuntu'."
		return 1 2>/dev/null || exit 1
		;;
esac