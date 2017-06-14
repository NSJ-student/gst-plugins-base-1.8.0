#!/bin/bash
# shell script to automately compile gstreamer library
# save all outputs to ~/gst-1.8.0/out

RED='\033[;31m'
GREEN='\033[;32m' 
YELLOW='\033[;33m'
BLUE='\033[;34m'
NC='\033[0m'

VERSION=1.8.0
GST_OUT_PATH=/home/$USER/gst_$VERSION/out
GST_INCLUDE_PATH=${GST_OUT_PATH}/include/gstreamer-1.0/gst

export PKG_CONFIG_PATH=${GST_OUT_PATH}/lib/pkgconfig

get_input() {
	local DEFAULT_PATH
	case $1 in
		"GST_OUT_PATH") DEFAULT_PATH=${GST_OUT_PATH} ;;
		"GST_INCLUDE_PATH") DEFAULT_PATH=${GST_INCLUDE_PATH} ;;
		"PKG_CONFIG_PATH") DEFAULT_PATH=${PKG_CONFIG_PATH} ;;
	esac
	echo -ne "${YELLOW}USE DEFAULT ${1}${NC}=${DEFAULT_PATH} ${YELLOW}[Y/N]${NC}: "
	read ans
	# use only one character (do not enter)
#	tty_state=$(stty -g)
#	stty raw
#	ans=$(dd bs=1 count=1 2> /dev/null)
#	stty "$tty_state"
#	echo ""

	if [[ "$ans" == "N" || "$ans" == "n" || "$ans" == "no" ]]; then	
		# all input is accepted as 'Y' unless it's 'N' or 'n'
		echo -ne "${YELLOW}Enter New ${1}: ${NC}"
		read new
		if [ ! -d $new ]; then
			echo -e "${RED}[ ${new} ] doesn't exist. use default path [ $DEFAULT_PATH ]${NC}"
		else
			export ${1}=${new}
			case $1 in
				"GST_OUT_PATH") DEFAULT_PATH=${GST_OUT_PATH} ;;
				"GST_INCLUDE_PATH") DEFAULT_PATH=${GST_INCLUDE_PATH} ;;
				"PKG_CONFIG_PATH") DEFAULT_PATH=${PKG_CONFIG_PATH} ;;
			esac
			echo -e "${GREEN}Setting new ${1}=${DEFAULT_PATH}${GREEN}"
		fi
	else
		echo -e "${GREEN}use default path [ $DEFAULT_PATH ]${NC}"
	fi
}

echo -e "${GREEN} ============== Start make${NC}"
get_input GST_OUT_PATH
get_input GST_INCLUDE_PATH
get_input PKG_CONFIG_PATH

if [ "configure" == "$1" ]; then 
	echo -e "${RED} ============== Do configure${NC}"
	./configure --prefix=${GST_OUT_PATH}
else
	echo -e "${RED} ============== Do not configure${NC}"
fi

make
make install

if [ ! -d ${GST_INCLUDE_PATH}/xvimage ]; then
	echo -e "${YELLOW} ============== Make directory  ${GST_INCLUDE_PATH}/xvimage${NC}"
	mkdir ${GST_INCLUDE_PATH}/xvimage
fi
echo -e "${YELLOW} ============== cp ./sys/xvimage/*.h ${GST_INCLUDE_PATH}/xvimage${NC}"
cp ./sys/xvimage/*.h ${GST_INCLUDE_PATH}/xvimage
echo -e "${GREEN} ============== Done${NC}"

