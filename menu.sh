#!/bin/bash

data_file="data/database.csv"
options_list=(
	"Prenota"
	"Elimina Prenotazione"
	"Mostra Aula"
	"Prenotazioni per aula"
	"Esci")
options_count=${#options_list[@]}



	##
	#sort -k 2,2 -k 1,1 file.txt      -t, --field-separator=SEP
	##
	
function main_menu
{
	echo_section "Menu Principale" $c_orange
	while true
	do
		print_menu
		
		#echo_color "Hello "$(whoami)", choose an option: " $c_blue -n
		#read chosen
		
		read -r -e -p "Hello "$(whoami)", choose an option: " -n 1
		
		case $REPLY in
			1) reserve ;;
			2) delete_reservation ;;
			3) show_classroom ;;
			4) show_reservations ;;
			5) quit ;;
			*) echo_color "Error: Only numbers from 1 to 5" $c_red ;;
		esac
		
		echo ""
	done
}

function print_menu
{
	for ((i = 0; i < $options_count; i++))
	do
		n=$(($i+1))
		echo -e $c_orange"$n)$c_def ${options_list[$i]}"
	done
}

function reserve
{
	echo_section "Prenotazioni" $c_orange
	
	classrooms=("Gino Tessari" "Alpha" "Delta" "Gamma" "A" "B" "C" "D" "E" "F" "G" "H" "I" "L" "M")
	
	while :
	do
		echo_color "Classroom (${classrooms[*]}): " $c_blue -n
		read in_classroom						 ##,, to lowercase
		if [[ ! -z $in_classroom && "${classrooms[@];;}" =~ "${in_classroom,,}" ]]; then 
			break
		else
			echo_color "Error: choose a room from the list." $c_red
		fi
	done
	
	while :
	do
		echo_color "Username: " $c_blue -n
		read in_username
		[[ ! -z $in_username ]] && break
	done
	 
	while :
	do 
		echo_color "Date (example 23/06/1912): " $c_blue -n
	 	read in_date
	 	if [[ $(check_date_format $in_date) = "1" ]] ; then
		 	now=$(date +"%Y%m%d")
			formatted_date=$(date -d "$in_date" +"%Y%m%d")
	 		if [ $formatted_date -ge $now ]; then 
		 		break
		 	else
		 		echo_color "Error: this date is not in the future" $c_red
			fi
	 	else
		 	echo_color "Error: format dd-mm-year (example 23/06/1912)" $c_red
	 	fi
	done
	
	
	while :
	do
		echo_color "Hour <from 8> <to 17> (example: 9 12): " $c_blue -n
		read hour_line
		read hour_from hour_to <<< $hour_line
		
	 	if [[ $hour_from -ge 8 && $hour_from -le 17  && $hour_to -ge 8 && $hour_to -le 17 ]] ; then
		 	break
	 	else
		 	echo_color "Error: the university is closed before 8 and after 17" $c_red
	 	fi
	done
	
	read -n 1 -r -e -p "Reserve classroom \"$in_classroom\" for $in_username in date $in_date at $hour_from to $hour_to ? [y/n] " 
	
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo_color "Done!" $c_green
		
		formatted_date=$(date -d "$in_date" +"%Y%m%d")
		echo "$in_classroom;$formatted_date;$hour_from-$hour_to;$in_username" >> $data_file
	fi

	
}

function reservation_exists
{
	echo "not implemented"
}

function delete_reservation
{
	echo "not implemented"
}

function show_classroom
{
	echo "not implemented"
}

function show_reservations
{
	echo "not implemented"
}

function quit
{
	echo_color "Buona giornata!" $c_indaco
	exit
}




