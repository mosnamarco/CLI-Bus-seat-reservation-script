#! /bin/bash

db=

# Dispplay and format db
displayAndFormat() {
	db="./db"
	# Format db
	row1=$(awk '{if ($1=="1R") {printf "%s - %s\n", $2, $3}}' "$db")
	row2=$(awk '{if ($1=="2R") {printf "%s - %s\n", $2, $3}}' "$db")

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


	while IFS="" read -r seat || [ -n "$seat" ]; do
		for token in $(echo ${reserveQuery}); do
			if [ ${seat:3:2} == $token ]; then 
				if [ ${seat:6:1} == "R" ] || [ ${seat:6:1} == "X" ]; then
					echo "Seat ${seat:0:6} is unavailable"
				else
					sed -i "s/$seat/${seat:0:6}R/" "$db"
					echo "Seat ${seat:0:6} successfully reserved"
				fi
			fi	
		done
	done < "$db"

	echo -e "\n[ New 2x2 seats status ]"
	displayAndFormat
}
# Display reserved

# Display taken

echo "[ Current 2x2 seat status ]"
displayAndFormat

echo -e "\n[ Operations ]\nR - reserve seats\nX - remove reservation\nLA - list available seats\nLX - list unavailable seats\n"
read -p "Enter operation: " userinput

operation=${userinput,,}

if [ $operation == "r" ]; then
	createReservation
elif [ $operation == "x" ]; then
	echo "remove"
elif [ $operation == "la" ]; then
	echo "list available"
elif [ $operation == "lx" ]; then
	echo "list unavaiable"
else
	echo "nope, bad operation"
fi	
