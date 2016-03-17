#!/bin/bash

data_file="data/database.csv"
options_list=(
	"Prenota"
	"Elimina Prenotazione"
	"Mostra Aula"
	"Prenotazioni per aula"
	"Esci")
options_count=${#options_list[@]}

classrooms=("Gino Tessari" "Alpha" "Delta" "Gamma" "A" "B" "C" "D" "E" "F" "G" "H" "I" "L" "M")
	


function main_menu
{
	while true
	do
		print_menu
		
		read -r -e -p "Hello "$(whoami)", choose an option: " -n 1
		
		case $REPLY in
			1) reserve ;;
			2) delete_reservation ;;
			3) show_classroom ;;
			4) show_reservations ;;
			5) quit ;;
			*) echo_color "Error: Only numbers from 1 to 5" $c_red ;;
		esac
		
		wait_input
		
	done
}

function print_menu
{

	echo_section "Menu Principale" $c_orange
	
	for ((i = 0; i < $options_count; i++))
	do
		n=$(($i+1))
		echo -e $c_orange"$n)$c_def ${options_list[$i]}"
	done
}

function reserve
{
	echo_section "${options_list[0]}" $c_orange
	
	#Classroom
	get_classroom in_classroom 
	
	#Username
	while :
	do
		echo_color "Username: " $c_blue -n
		read in_username
		[[ ! -z $in_username ]] && break
	done
	 
	#Date
	while :
	do 
		echo_color "Date (year/month/day): " $c_blue -n
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
		 	echo_color "Error: format year/month/day (example "$(date +"%Y/%m/%d")")" $c_red
	 	fi
	done
	
	
	#Hour range	
	while :
	do
		echo_color "Hour <from H> <to H> (example: 9 12): " $c_blue -n
		read hour_line
		read hour_from hour_to <<< $hour_line
		
		[[ -z $hour_to ]] && hour_to=$hour_from
		
	 	if [[ $hour_from -ge 8 && $hour_from -le 17  && $hour_to -ge 8 && $hour_to -le 17 ]]
	 	then
			if [[ $(reservation_exists $in_classroom $formatted_date $hour_from $hour_to) = "1" ]]
			then 
				echo "This room is already reserved in this hour range"
			else
			 	break
		 	fi
	 	else
		 	echo_color "Error: the university is closed before 8 and after 17" $c_red
	 	fi
	done
	
	#Prompt to save
	while :
	do
		read -n 1 -r -e -p "Reserve room \"$in_classroom\" for $in_username in date $in_date from $hour_from to $hour_to ? [y/n] " 
	
		if [[ $REPLY =~ ^[Yy]$ ]] ; then
			echo "$in_classroom;$formatted_date;$hour_from;$hour_to;$in_username" >> $data_file
			echo_color "Done!" $c_green 
			break
		elif [[ $REPLY =~ ^[Nn]$ ]] ; then
			break
		fi
	done
}

function get_classroom
{
	
	while :
	do
		echo_color "Classroom (${classrooms[*]}): " $c_blue -n
		read in_classroom						
		
		if [[ ! -z $in_classroom ]]
		then 
			found=false 
			
			for room in "${classrooms[@]}"
			do
				if [ $(to_lowercase $room) = $(to_lowercase $in_classroom) ] ; then
					found=true
					in_classroom=$room
					break;
				fi
			done
			
			if [[ $found = true ]]; then
				break
			else
				echo_color "Error: choose a room from the list." $c_red
			fi
		fi
	done
	eval "$1='$in_classroom'" 
}

#arguments: classroom, date, hour_from, hour_to
function reservation_exists
{
	#search for the date and get the 3th and 4th column
	for range in $( grep -i "$1;$2" $data_file | cut -d ';' -f 3,4 ) 
	do
		hour_from=$(echo $range | cut -f 1 -d ';')
		hour_to=$(echo $range | cut -f 2 -d ';')
		if [[ ( $3 -ge $hour_from && $3 -le $hour_to ) ||
			  ( $4 -ge $hour_from && $4 -le $hour_to ) ]] ; then
		 	echo 1
		 	return
	 	fi
	done
	
	echo 0
}

function delete_reservation
{
	echo_section "${options_list[1]}" $c_orange
	echo "not implemented"
}

function show_classroom
{
	echo_section "${options_list[2]}" $c_orange
	get_classroom in_classroom
	echo ""
	output=$(echo -e "User|Date|From|To\n")
	for line in $(grep "$in_classroom;" $data_file | sort -k 2n -k 3n --field-separator=";")
	do 
		set_separator ";"
		read in_classroom in_date in_hour_from in_hour_to in_username <<< "$line"
		reset_separator
		in_date=$(date -d "$in_date" +"%d/%m/%Y")
		output="$output\n$in_username|$in_date|$in_hour_from|$in_hour_to"
	done 
	echo -e "$output" | column -t -s "|"
}

function show_reservations
{
	echo_section "${options_list[3]}" $c_orange
	for classroom in "${classrooms[@]}"
	do
		count=$(grep -c "$classroom;" $data_file)
		[[ $count -gt 0 ]] && echo "$classroom: $count"
	done
}

function quit
{
	echo_section "${options_list[4]}" $c_orange
	echo_color "Buona giornata!\n" $c_indaco
	exit
}




