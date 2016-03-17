#!/bin/bash

data_file="data/database.csv"
options_list=(
	"Prenota"
	"Elimina Prenotazione"
	"Mostra Aula"
	"Prenotazioni per aula"
	"Esci")
options_count=${#options_list[@]}

function main_menu
{
	s1="05/12/1991"
	s2="999"
	s3="05-12-1991"
	s4="05 12 1991"
	[[ $s1  =~  ^[0-9/]+$ ]] && echo "ok1" || echo "no"
	[[ $s2  =~  ^[0-9]+$ ]] && echo "ok2" || echo "no"
	[[ $s3  =~  ^[0-9]+$ ]] && echo "ok3" || echo "no"
	[[ $s4  =~  ^[0-9]+$ ]] && echo "ok4" || echo "no"
	
	echo_section "Menu Principale" $c_orange
	while true
	do
		print_menu
		
		echo_color "Hello "$(whoami)", choose an option: " $c_blue -n
		read chosen
		case $chosen in
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
	
	classrooms=("tessari" "alpha" "delta" "gamma" "a" "b" "c" "d" "e" "f" "g" "h" "i" "l" "m")
	
	while :
	do
		echo_color "Classroom (${classrooms[*]}): " $c_blue -n
		read in_classroom						 ##,, to lowercase
		if [[ ! -z $in_classroom && "${classrooms[@]}" =~ "${in_classroom,,}" ]]; then 
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
	 	if [[ $(check_date $in_date) = "1" ]] ; then
		 	break
	 	else
		 	echo_color "Error: format dd-mm-year (example 23/06/1912)" $c_red
	 	fi
	done
	
	while :
	do 
		echo_color "Hour (8 to 17): " $c_blue -n
	 	read in_hour
	 	if [[ $in_hour -ge 8 && $hour -le 17 ]] ; then
		 	break
	 	else
		 	echo_color "Error: the university is closed at $in_hour" $c_red
	 	fi
	done
	echo_color "Reserved room \"$in_classroom\" for $in_username in date $in_date" $c_green
	
	formatted_date=$(date -d "$in_date" +"%Y%m%d")
	echo $formatted_date
	
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




