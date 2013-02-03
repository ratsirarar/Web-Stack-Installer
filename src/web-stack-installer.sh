#!/bin/bash
 
: 'This script is installing web stack environment for either Python or Ruby:
  What are installed for Python:
  		-- git 
		-- pythonbrew
		-- mongodb
		-- sqlite3

  Other goodies for OSX:
  		-- brew
  		-- wget
'

SOURCE_SHELL_OSX=~/.bash_profile 
SOURCE_SHELL_LINUX=~/.bashrc

NOT_FOUND="not found"

pre_install_env_osx ()
{
	install_brew
	_install_package wget git mongodb sqlite 
	install_python_brew
}

pre_install_linux ()
{
	no_ruby=`which ruby`

	if [ -z $no_ruby -o -n $(echo $no_ruby | grep "$NOT_FOUND") ]; then
		echo "ruby not found"
	else 
		echo "ruby found"
	fi
}

install_brew () {
	LINK_BREW="/usr/bin/ruby -e \"$(curl -fsSkL raw.github.com/mxcl/homebrew/go)\""
	_install_curl_pack /usr/local/bin "brew" "$LINK_BREW"
}

install_python_brew()
{
	LINK_PYTHON_BREW="curl -kL http://xrl.us/pythonbrewinstall | bash"
	_install_curl_pack ~ pythonbrew "$LINK_PYTHON_BREW"
    
    echo -e "\n # Pythonbrew source: remove this when uninstalling pythonbrew" >> $SOURCE_SHELL_OSX
	echo "[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc" >> $SOURCE_SHELL_OSX


}

_welcome () {
	echo -e "\n Welcome to Web Stack Installer"
	echo -e "\n This script is installing web stack environment for either Python or Ruby:
  What are installed for Python:
  		-- git 
		-- pythonbrew
		-- mongodb
		-- sqlite3

  Other goodies for OSX:
  		-- brew
  		-- wget
"
}

_thank_you()
{
	echo -e "\n Thank you for using Web Stack installer!!"
}

_install_package () {
	OS_NAME=`uname`
	if [ "$OS_NAME" == "Darwin" ]; then
		pack_inst="brew"
	else 
		pack_inst="sudo apt-get"
			pre_install_linux
	fi

	for param in $@; do
		$pack_inst install $param
	done
}

# install package from web
# 	@params: 
# 		-folder containing the package if already installed
# 		-name of the package
# 		-link to download the package
# 	example usage:
# 		install_curl_pcak ~ virtualenv "curl git://git-hub.com/virtualenv/go"
_install_curl_pack() {
    has_pack=`ls -la $1 | grep "$2"`
	if [ -n "`echo $has_pack`" ]; then
		echo "$2 already installed"
	else 
		echo "installing $2"
		eval $3
	fi
} 

main () {
	_welcome

	echo -e "\n What development Stack do you want to work on Today? [Python/Ruby]
	 \n \t 1-Python \n \t 2-Ruby"
	read choice_stack

	OS_NAME=`uname`
	if [ "$OS_NAME" == "Darwin" ]; then
		echo -e "\n Mhhh ... I see you are using your Mac!!!"	
		if [ $choice_stack == "Python" -o $choice_stack == 1 ]; then
			# For OSX we assume ruby is installed by default
			pre_install_env_osx
		fi
	elif [ "$OS_NAME" == "Linux"]; then
			echo 'Yay, You are using Linux!!!'
			pre_install_linux
	fi

	_thank_you
}
main
