#set -e
#set -x

# pip uninstall awscli || pip3 uninstall awscli || pip3.6 uninstall awscli
# rm -rf "${HOME}/.aws"
# cd /keybase/private/luyi985/AWS_LYI_Admin/

awsConfidentail="./accessKeys.csv"
awsConfig="${HOME}/.aws/config"
awsCredentials="${HOME}/.aws/credentials"

readNthLine() {
	id=0
	while read -r line; do
		id=$((id + 1))
		if [[ $id -eq $2 ]]; then
			echo $line
		fi
	done < "${1}"
}

writeConfig(){
	echo "[default]" > $awsConfig &&
	echo "region=ap-southeast-2" >> $awsConfig &&
	echo "output=json" >> $awsConfig
	return $?
}

writeCredentials(){
	echo "[default]" > $awsCredentials &&
	echo "aws_access_key_id=${1}" >> $awsCredentials &&
	echo "aws_secret_access_key=${2}" >> $awsCredentials
	return $?
}

installAWSCLI(){
	aws --version && return 0

	pip3 install awscli --upgrade --user

	aws --version && return 0

	local bashSrc
	local pySrc=$(readlink $(which python3.6))
	local awsLocation
	pySrc="${pySrc//..\/}"
	pySrc="${pySrc%/*}"

	[[ -f "${HOME}/.bashrc" ]] && bashSrc="${HOME}/.bashrc"
	[[ -f "${HOME}/.bash_profile" ]] && bashSrc="${HOME}/.bash_profile"
	[[ -f "${HOME}/.local/bin/aws" ]] && awsLocation="${HOME}/.local/bin/"
	[[ -f "/${pySrc}/aws" ]] && awsLocation="/${pySrc}/"
	[[ -f "${HOME}/Library/Python/3.6/bin/aws" ]] && awsLocation="${HOME}/Library/Python/3.6/bin/"

	[[ -n $awsLocation ]] &&
	echo "" >> "${bashSrc}" &&
	echo "export PATH=\"${awsLocation}:$PATH\"" >> "${bashSrc}" &&
	chmod +x "${awsLocation}aws" &&
	export PATH="${awsLocation}:$PATH"

	aws --version
	return $?
}

[[ -f ${awsConfidentail} ]] && {
	awsStr=$(readNthLine ${awsConfidentail} 2)
	awsSecret="${awsStr#*,}"
	awsKey="${awsStr%,*}"

	[[ -d "${HOME}/.aws" ]] || mkdir "${HOME}/.aws"

	installAWSCLI && writeConfig && writeCredentials "${awsKey}" "${awsSecret}" && {
		echo "${awsConfig}-----"
		cat $awsConfig
		echo "${awsCredentials}-----"
		cat $awsCredentials
	}
	exit $?
}
