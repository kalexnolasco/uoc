#!/bin/bash

#-------------------------------------------------------------------------------------------------
# This script synchronize the python env multiproject selected in indicated server using kalex as user
#
# EXECUTE: ./rsync.sh <user>@<server> -m <module>
#-------------------------------------------------------------------------------------------------
LIST_ENV=(d09 d10)
REMOTE_USER="kalex"

if [ $# -ne 3 ]
then
	echo "- Destination server and module name required (./rsync.env.sh <server> -m <module> ) (./rsync.env.sh <server> -all)"
	exit 1
fi

function sync () {
	local PATH_REM=/home/$REMOTE_USER/uoc/
	local MODUL=$(echo $2 | tr -d '/')
	local MODUL=${MODUL//:/ }

	# check projects
	for project in $MODUL; do
		if [ ! -d "./$project" ];
		then
			echo "-Invalid project name (not found): $project"
			exit 1
		fi
	done
	rsync -rltDvz --exclude 'test' --exclude '*.pyc' --exclude '.git' --delete --chmod=775 run.sh requirements.txt $MODUL $REMOTE_USER@$1:$PATH_REM
}

# Move to the script dir to be sure al the scripts working
cd $(dirname $0)

# check option
case $2 in
	"-all"|"-m")
		;;
	*)
		echo "- Invalid option (-m (module) / -all): "$2
		exit 1
		;;
esac

if [ $2 == "-m" ];
then
	echo "- Updating host: [$1] with module: [$3] "
	sync $1 $3
elif [ $2 == "-all" ];
then
  sync $1
fi
exit 0