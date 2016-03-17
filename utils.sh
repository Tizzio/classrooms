#!/bin/bash

c_def="\e[0m"
c_grey="\e[30m"
b_grey="\e[40m"
c_red="\e[31m"
b_red="\e[41m"
c_green="\e[32m"
b_green="\e[42m"
c_orange="\e[33m"
b_orange="\e[43m"
c_blue="\e[34m"
b_blue="\e[44m"
c_purple="\e[35m"
b_purple="\e[45m"
c_indaco="\e[36m"
b_indaco="\e[46m"


current_color=$c_def

default_separator="$IFS"

function set_separator
{
	IFS="$@"
}

function reset_separator
{
	IFS="$default_separator"
}

function echo_section
{
	echo -e "\n${2}o~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~o\n|  $1\no~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~o$c_def"
}
 
function echo_color
{
	echo -e $3 "$2$1$c_def"
}

function wait_input
{
	echo ""
	read -p "Press any key to continue..." -n 1
}

function print
{
	echo -e "$current_color$1$c_def"
}

function check_date_format
{
	#at least 5 characters
	if [[ ${#1} -gt 5 && $1 =~ ^[0-9/]+$ ]] ; then
		# redirect standard error(2) to standard out (1)
		# without &, the following 1 would be considered a filename
		date -d "$1" +"%Y%m%d" > /dev/null  2>&1
		[[ "$?" = "0" ]] && echo "1" || echo "0"
	else
		echo "0"
	fi
}
   
function to_lowercase
{
	echo $1 | tr "[:upper:]" "[:lower:]"
}

#my_path=$(readlink -e "$BASH_SOURCE") #read the full file path
#my_dir=$(dirname "$my_path") #extract the folder from the path



