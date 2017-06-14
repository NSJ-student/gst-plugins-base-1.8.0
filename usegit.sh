if [ ! -e /usr/bin/git ]; then
	echo "git doesn't exist."
	echo -n "Want to install git? [Y/N]:"
	read ANS
	case $ANS in
		[Yy]) sudo apt-get install -y git;;
		[Nn]) exit;;
		*) exit;;
	esac
fi

if [ "$1" != "clone" -a "$1" != "add-all" -a "$1" != "add" -a "$1" != "upload" -a "$1" != "init" ]; then
	echo "Usage:"
	echo "  $0 init     = init git"
	echo "  $0 clone     = load from git"
	echo "  $0 add-all  = add all files in this directory to git"
	echo "  $0 add # #  = add specified files to git"
	echo "  $0 upload   = upload to git"
	exit
fi

echo -n "Want to user default git? [Y/N]:"
read ANS
if [[ "y" == "$ANS" || "Y" == "$ANS" ]]; then
	USER_NAME=NSJ-student
	USER_EMAIL=ghdlghdl0558@gmail.com
	USER_GIT=gst-plugins-base-1.8.0
else
	echo -n "Input user.name: "
	read USER_NAME
	echo -n "Input user.email: "
	read USER_EMAIL
	echo -n "Input clone repository: "
	read USER_GIT
fi

git config --global user.name "$USER_NAME"
git config --global user.email $USER_EMAIL
CLONE_GIT=https://github.com/${USER_NAME}/${USER_GIT}.git
if [ "$1" == "clone" ]; then
	if [ ! -e ./${USER_GIT} ]; then
		git clone $CLONE_GIT
		echo "clone $CLONE_GIT"
		if [ ! -e ./${USER_GIT} ]; then
			echo "clone failed"
			exit
		fi
	else
		echo "[ $CLONE_GIT ] already exists"
	fi

	cd $USER_GIT
	git remote add origin $CLONE_GIT
elif [[ "$1" == "init" ]]; then
	git init
	git add README.md
	git commit -m "first commit"
	git remote add origin $CLONE_GIT
elif [[ "$1" == "add-all" ]]; then
	echo "upload $USER_GIT to github"
	git add * --all
elif [[ "$1" == "add" ]]; then
	echo "upload $USER_GIT to github"
	for a in $@
	do
		if [ "$a" != "add" ]; then
			echo "git add $a"
			git add $a
		else
			echo "ignore $a"
		fi
	done
elif [[ "$1" == "upload" ]]; then
	echo "upload $USER_GIT to github"
	git commit -a
	git push --set-upstream origin master
else
	echo "invalid arg [ $1 ]"
fi
