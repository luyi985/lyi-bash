#set -e
#set -x

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
	aws --version >> /dev/null
	[[ $? -eq 0 ]] || {
		pip install awscli --upgrade --user && aws --version
	}
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
