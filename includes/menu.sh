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
	get_username in_username
	 
	#Date
	get_date in_date formatted_date

	#Hour range	
	get_hour_range hour_from hour_to
	
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


function delete_reservation
{
	echo_section "${options_list[1]}" $c_orange
	
	#Classroom
	get_classroom in_classroom 
	
	#Date
	get_date in_date formatted_date

	#Hour range	
	echo_color "Hour: " $c_blue -n
	read in_hour
	
	pattern="$in_classroom;$formatted_date;$in_hour"
	echo -e "$(grep -v "$pattern" $data_file)" > $data_file 
}

function show_classroom
{
	echo_section "${options_list[2]}" $c_orange
	get_classroom in_classroom
	echo ""
	output=$(echo -e "User|Date|From|To\n")
	
	set_separator $'\n'
	for line in $(grep "$in_classroom;" $data_file | sort -k 2n -k 3n --field-separator=";")
	do
		set_separator ";"
		read in_classroom in_date in_hour_from in_hour_to in_username <<< "$line"
		reset_separator
		
		in_date=$(date -d "$in_date" +"%Y/%m/%d")
		output="$output\n$in_username|$in_date|$in_hour_from|$in_hour_to"
		
		set_separator $'\n' #set the newline separator for the next iteration
	done
	reset_separator
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



