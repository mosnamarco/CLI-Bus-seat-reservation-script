#! /bin/bash

db=

# Dispplay and format db
displayAndFormat() {
	db="./db"
	row1=
	row2=

	if [ "$1" == "la" ]; then
	# Format db
		row1=$(awk '{if ($1=="1R" && $3=="A") {printf "%s - %s\n", $2, $3}}' "$db")
		row2=$(awk '{if ($1=="2R" && $3=="A") {printf "%s - %s\n", $2, $3}}' "$db")
	elif [ "$1" == "lx" ]; then
		row1=$(awk '{if ($1=="1R" && $3=="R") {printf "%s - %s\n", $2, $3}}' "$db")
		row2=$(awk '{if ($1=="2R" && $3=="R") {printf "%s - %s\n", $2, $3}}' "$db")
	else
		row1=$(awk '{if ($1=="1R") {printf "%s - %s\n", $2, $3}}' "$db")
		row2=$(awk '{if ($1=="2R") {printf "%s - %s\n", $2, $3}}' "$db")
	fi

	# Display current db seats
	echo -e "Row 1\tRow 2"
	echo -e "------\t------"
	result=$(paste <(echo "$row1") <(echo "$row2"))
	echo "$result"
}

# Create reservation
createReservation() {
	echo -e "\nNote: Entering an already reserved or unavailable seat number will re-prompt you to list seats number again\n"
	read -p "List seat numbers you wish to reserve (i.e., 01 02 03 09 10): " reserveQuery
	echo -e "\n"

	while IFS="" read -r seat || [ -n "$seat" ]; do
		for token in $(echo ${reserveQuery}); do
			if [ ${seat:3:2} == $token ]; then 
				if [ "$1" == "destroy" ]; then
					sed -i "s/$seat/${seat:0:6}X/" "$db"
					echo "Seat ${seat:0:6} successfully made unavailable"
				elif [ "$1" == "remove" ]; then
					if [ ${seat:6:1} == "R" ]; then
						sed -i "s/$seat/${seat:0:6}A/" "$db"
						echo "Successfully removed ${seat:0:6} reservation"
					elif [ ${seat:6:1} == "X" ]; then
						echo "Cannot remove reservation of an unavailable seat ${seat:0:6}"
					elif [ ${seat:6:1} == "A" ]; then
						echo "Seat ${seat:0:6} already available"
					fi
				else
					if [ ${seat:6:1} == "R" ] || [ ${seat:6:1} == "X" ]; then
						echo "Seat ${seat:0:6} is unavailable"
					else
						sed -i "s/$seat/${seat:0:6}R/" "$db"
						echo "Seat ${seat:0:6} successfully reserved"
					fi
				fi
					
			fi	
		done
	done < "$db"

	echo -e "\n[ New 2x2 seats status ]"
	displayAndFormat
}

echo "[ Current 2x2 seat status ]"
displayAndFormat

echo -e "\n[ Operations ]\nR - reserve seats\nREM - remove reservation\nLA - list available seats\nLX - list unavailable seats\n"
read -p "Enter operation: " userinput

operation=${userinput,,}

if [ $operation == "r" ]; then
	createReservation
elif [ $operation == "rem" ]; then
	createReservation "remove"
elif [ $operation == "la" ]; then
	echo -e "\nDisplaying available seats"
	displayAndFormat "la"
elif [ $operation == "lx" ]; then
	echo -e "\nDisplaying reserved seats"
	displayAndFormat "lx"
else
	echo "nope, bad operation"
fi	
