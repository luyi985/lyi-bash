#set -e
# set -x
 rm -rf ~/.aws/
 pip3 uninstall awscli
 cd /keybase/private/luyi985/AWS_LYI_Admin/

awsConfidentail="./accessKeys.csv"
awsConfig="${HOME}/.aws/config"
awsCredentials="${HOME}/.aws/credentials"
awsRegion="ap-southeast-2"

[[ -z ${LYI_BASH} ]] && exit 1
[[ -z ${LYI_BASH} ]] || source "${LYI_BASH}/func.sh"

pySrc=$(readlink $(which python3.6))
pySrc="${pySrc//..\/}"
pySrc="${pySrc%/*}"

[[ -f "${HOME}/.bashrc" ]] && { bashSrc="${HOME}/.bashrc"; }
[[ -f "${HOME}/.bash_profile" ]] && { bashSrc="${HOME}/.bash_profile"; }

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
	echo "region=${awsRegion}" >> $awsConfig &&
	echo "output=json" >> $awsConfig
	return $?
}

writeCredentials(){
	echo "[default]" > $awsCredentials &&
	echo "aws_access_key_id=${1}" >> $awsCredentials &&
	echo "aws_secret_access_key=${2}" >> $awsCredentials &&
	echo "" >> ${bashSrc} &&
	UPDATE_VAR_IN_FILE ${bashSrc} aws_access_key_id ${1} &&
	UPDATE_VAR_IN_FILE ${bashSrc} aws_secret_access_key ${2} 
	return $?
}

installAWSCLI(){
	local awsLocation
	aws --version && return 0

	pip3 install awscli --upgrade --user

	aws --version && return 0

	[[ -f "${HOME}/.local/bin/aws" ]] && { awsLocation="${HOME}/.local/bin/"; }
	[[ -f "/${pySrc}/aws" ]] && { awsLocation="/${pySrc}/"; }
	[[ -f "${HOME}/Library/Python/3.6/bin/aws" ]] && { awsLocation="${HOME}/Library/Python/3.6/bin/"; }

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
	awsSecret="${awsSecret%$'\r'}"
	awsKey="${awsStr%,*}"
	awsKey="${awsKey%$'\r'}"

	[[ -d "${HOME}/.aws" ]] || mkdir "${HOME}/.aws"

	installAWSCLI && writeConfig && writeCredentials "${awsKey}" "${awsSecret}" && {
		success "${awsConfig}-----"
		cat $awsConfig
		success "${awsCredentials}-----"
		cat $awsCredentials
	}
	exit $?
}