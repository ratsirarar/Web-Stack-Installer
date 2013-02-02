#!/bin/bash

# This script is installing django stack environment:
#   For OSX:
# 	What are installed:
# 		-- brew
# 		-- wget 
#       -- git
# 		-- pythonbrew
# 		-- mongodb
# 		-- sqlite3

# For OSX we assume ruby is installed by default

SOURCE_SHELL_OSX=~/.bash_profile
SOURCE_SHELL_LINUX=~/.bashrc

NOT_FOUND="not found"

pre_install_mac_osx ()
{
	install_brew
	install_package wget git mongodb sqlite 
	install_python_brew
	thank_you
}

install_package () {
	for param in $@; do
		brew install $param
	done
}


# install package from web
# 	@params: 
# 		-folder containing the package if already installed
# 		-name of the package
# 		-link to download the package
# 	example usage:
# 		install_curl_pcak ~ virtualenv "curl git://git-hub.com/virtualenv/go"
install_curl_pack() {
    has_pack=`ls -la $1 | grep "$2"`
	if [ -n "`echo $has_pack`" ]; then
		echo "$2 already installed"
	else 
		echo "installing $2"
		eval $3
	fi
} 

install_brew () {
	LINK_BREW="/usr/bin/ruby -e \"$(curl -fsSkL raw.github.com/mxcl/homebrew/go)\""
	install_curl_pack /usr/local/bin "brew" "$LINK_BREW"
}

install_python_brew()
{
	LINK_PYTHON_BREW="curl -kL http://xrl.us/pythonbrewinstall | bash"
	install_curl_pack ~ pythonbrew "$LINK_PYTHON_BREW"
    
    echo -e "\n # Pythonbrew source: remove this when uninstalling pythonbrew" >> $SOURCE_SHELL_OSX
	echo "[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc" >> $SOURCE_SHELL_OSX


}

thank_you()
{
	echo -e "\n Thank you for using Web Stack installer!!"
}

OS_NAME=`uname`

if [ "$OS_NAME" == "Darwin" ]; then
	echo 'Getting fancy with your Mac'
	pre_install_mac_osx
	
else 
	echo ''
fi


