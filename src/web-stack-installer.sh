#!/bin/bash
 
: 'This script is installing web stack environment for either Python or Ruby:
  What are installed for Python:
  		-- git 
		-- pythonbrew
		-- sqlite3

  Other goodies for OSX:
  		-- brew
  		-- wget

 @author Andy Ratsirarson 		
'

SOURCE_SHELL_OSX=~/.bash_profile 
SOURCE_SHELL_LINUX=~/.bashrc

NOT_FOUND="not found"

pre_install_env_osx ()
{
	install_brew
	_install_package wget git sqlite 
	install_python_brew
	setup_virtual_env
}

pre_install_linux ()
{
	_install_package git-core sqlite
	install_python_brew
	setup_virtual_env
}

install_brew () {
	LINK_BREW="/usr/bin/ruby -e \"$(curl -fsSkL raw.github.com/mxcl/homebrew/go)\""
	_install_curl_pack /usr/local/bin "brew" "$LINK_BREW"
}

setup_virtual_env ()
{
	echo -e "\n As for now we only support Django1.4 installation [for older version, you can manually install it]"
	echo -e "Do you want to go ahead and setup Django in your virutal environment?[y/n]"
	read inst_django
	if [ "$inst_django" == "y" -o "$inst_django" == "Y" ]; then
		pythonbrew install 2.7.3
		pythonbrew switch 2.7.3
		echo -e "What would you name your virtual env instance?[default=django]"
		read inst_name
		if [ -z inst_name ];then
			_setup_pythonbrew django
			echo -e "Congratulation you have successfully installed django in your virtual env
					To start activate your virtual env: pythonbrew venv use django
					Check if django was installed correctly: pip freeze "
		else
			_setup_pythonbrew $inst_name
			echo -e "Congratulation you have successfully installed django in your virtual env
					To start activate your virtual env: pythonbrew venv use $inst_name
					Check if django was installed correctly: pip freeze "

		fi

	fi
}

install_python_brew()
{
	LINK_PYTHON_BREW="curl -kL http://xrl.us/pythonbrewinstall | bash"
	
	has_pythonbrew=`ls -la ~ | grep ".pythonbrew"`
	if [ -z "`echo $has_pythonbrew`" ]; then
		_install_curl_pack ~ pythonbrew "$LINK_PYTHON_BREW"
	    echo -e "\n # Pythonbrew source: remove this when uninstalling pythonbrew" >> $SOURCE_SHELL_OSX $SOURCE_SHELL_LINUX
		echo "[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc" >> $SOURCE_SHELL_OSX $SOURCE_SHELL_LINUX
	fi

}

_welcome () {
	echo -e "\n Welcome to Web Stack Installer"
	echo -e "\n This script is installing web stack environment for either Python or Ruby:
  What are installed for Python:
  		-- git 
		-- pythonbrew
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
	fi

	for param in $@; do
		echo -e "**** Installing $param ***\n"
		$pack_inst install $param
	done
}

_setup_pythonbrew ()
{
	pythonbrew venv create $1
	pythonbrew venv use $1
	pip install django
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
		if [ $choice_stack == "python" -o $choice_stack == 1 ]; then
			# For OSX we assume ruby is installed by default
			pre_install_env_osx
		fi
	elif [ "$OS_NAME" == "Linux" ]; then
			echo 'Yay, You are using Linux!!!'
			pre_install_linux
	fi

	_thank_you
}
main
