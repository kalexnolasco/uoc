#!/bin/bash

#-------------------------------------------------------------------------------------------------
#
#
# EXECUTE: ./run.sh <option>
#-------------------------------------------------------------------------------------------------
if [ $# -ne 1 ]
then
	echo "- required (./run.sh <module>)"
	echo "- Options:"
	echo "  * install:"
	echo "  * env:"
	echo "  * jupyter:"
	exit 1
fi
PATH_ENV=/home/$USER/env3

function install () {
	local PYTHON="python3 python3-dev python3-pip python-virtualenv gcc"
  local UTILITIES="apt-transport-https aptitude ca-certificates cron dirmngr fping git gcc htop lftp libauthen-pam-perl libio-pty-perl libnet-ssleay-perl libpam-runtime lsb-release man mlocate nano ncftp neofetch net-tools nfs-common nmap ntpdate openssh-server openssh-client openssl perl pigz python python-dev python-doc python-pip python-tk  python3 python3-doc python3-tk python3-venv rsync software-properties-common sudo tmux traceroute ufw unrar vim w3m wget whois zip"
  local EXTRA_MODULES="libsnmp-dev default-libmysqlclient-dev"

	sudo apt-get update && sudo apt-get -y upgrade
	sudo apt-get install -y $PYTHON $UTILITIES $EXTRA_MODULES
}

function environment () {
	rm -Rf $PATH_ENV
	python -m virtualenv --python=python3 $PATH_ENV && /bin/bash -c "source $PATH_ENV/bin/activate && pip install --upgrade pip && pip install -r requirements.txt"
}

function jupyter_notebook () {
	/bin/bash -c "source $PATH_ENV/bin/activate && jupyter notebook --no-browser --ip=0.0.0.0 --port=8888 --NotebookApp.token='' --NotebookApp.password='KAKA'"
}


# Move to the script dir to be sure al the scripts working
cd $(dirname $0)

if [ $1 == "install" ];
then
#	echo "- Updating host: [$1] with module: [$3] "
	install
elif [ $1 == "env" ];
then
  environment
elif [ $1 == "jupyter" ];
then
  jupyter_notebook
fi
exit 0



