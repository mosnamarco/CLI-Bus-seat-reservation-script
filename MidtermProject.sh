#! /bin/bash

db="./db"

# Format db
row1=$(awk '{if ($1=="1R") {printf "%s - %s\n", $2, $3}}' "$db")
row2=$(awk '{if ($1=="2R") {printf "%s - %s\n", $2, $3}}' "$db")

# Display current db seats
echo "Current 2x2 seats"
echo -e "Row 1\tRow 2"
echo -e "------\t------"
result=$(paste <(echo "$row1") <(echo "$row2"))
echo "$result"

# Create reservation

# Display reserved

# Display taken


