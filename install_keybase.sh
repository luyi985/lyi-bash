#https://keybase.io/docs/the_app/install_linux
curl --version || sudo apt-get install curl

keybase --version || {
	curl -O https://prerelease.keybase.io/keybase_amd64.deb
	# if you see an error about missing `libappindicator1`
	# from the next command, you can ignore it, as the
	# subsequent command corrects it
	sudo dpkg -i keybase_amd64.deb
	sudo apt-get install -f
	run_keybase
}