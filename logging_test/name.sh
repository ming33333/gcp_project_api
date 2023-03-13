#!/bin/bash
echo "Enter First Person Name : "

# It will take input from user i.e.
# First Person Name
read FName

# It store First Person Name in Log.txt
echo "First Person Name : $FName">Log.txt
echo
echo "Enter Second Person Name : "

# It will take input from user i.e. 
# Second Person Name
read SName

# It append Second Person Name in Log.txt
echo "Second Person Name : $SName">>Log.txt