
function get_classroom
{
	while :
	do
		echo_color "|"  $c_indaco -n
		for room in "${classrooms[@]}"
		do
			echo_color " $room |"  $c_indaco -n
		done
		
		echo_color "\nChoose a classroom: "  $c_blue -n
		
		read in_classroom				
		
		set_separator $'\n'
		
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
		reset_separator
	done
	reset_separator
	eval "$1='$in_classroom'" 
}

function get_date
{
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
	eval "$1='$in_date'"
	eval "$2='$formatted_date'"
}

function get_username
{
	while :
	do
		echo_color "Username: " $c_blue -n
		read in_username
		[[ ! -z $in_username ]] && break
	done
	eval "$1='$in_username'"
}

function get_hour_range
{
	while :
	do
		echo_color "Hour <from H> <to H> (example: 9 12): " $c_blue -n
		read hour_line
		read hour_from hour_to <<< $hour_line
		
		[[ -z $hour_to ]] && hour_to=$hour_from
	 	if [[ "$hour_from" -ge 8 && $hour_from -le 17  && $hour_to -ge 8 && $hour_to -le 17 ]]
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
	
	eval "$1='$hour_from'"
	eval "$2='$hour_to'"
}

