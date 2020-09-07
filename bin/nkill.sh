#!/bin/bash
#A script for killing processes using the name instead of numerical identifier.
#Does not require privilege escalation unless kill requires it.
#
#Error Codes
#	10		Incorrect number of arguments
#	20		Search failed and user wished to quit the script


cleanUp () #A function to silently remove any temporary files
{
		rm -f ~/.nksearch ~/.nkpidlist ~/.nkpso
}

procFileInit () #A function to initialize the process files
{
		#Outputs and formats ps results:
		#grep only outputs lines matching the argument
		#sed removes leading spaces
		ps -A | grep $argProc.*$ | sed 's/^[ ^t]*//' > ~/.nkpso
		
		#Trims the output to only the pids for storage in a seperate file
		cat ~/.nkpso | cut -f1 -d" " > ~/.nkpidlist
}


emptyListCheck () #A function to ensure that there are matching processes
{
		if [ ! -z "$(cat ~/.nksearch)" ]; then
				echo "ERROR: There are no running programs matching that name."
				echo -n "Press return to perform a search or type anything to exit: "
				read -e opt
				echo

				if [ -z "$opt" ]; then
						search
				else
						cleanUp
						exit 20
				fi
		fi
}

: <<'END'
procCompare () #A function to check that all pids are connected to a matching process name
{

		nameList=()

		for name in `cat ~/.nkpso`; do

				name=$(echo $name | grep -o $argProc.* )

				if ( -z "$( echo ${nameList[@]} | grep $name )"  ); then
						nameList+=$name
				fi

		done

		if [ "$( echo ${#nameList[@]})" -gt 1  ]; then
				echo These are the matching processes: ${nameList[@]}
				echo -n "Enter the desired name(s) seperated by a space or press return to select all of them: "
				read -e 
}
END

procSearch () #A function to search for processes
{
		if [ -z "$argProc" ]; then #Checks for an empty variable
		
				rm -f ~/.nksearch #Ensures that the output file does not exist
		
				#Performs search and outputs to temporary file
				echo -ne "\nPlease enter your search term: "
				read -e search
				echo
				search=$(echo $search | cut -b1-15) #Truncates the search term if necessary
		
				ps -A | grep -i $search > ~/.nksearch #case insensitive search, outputs to temporary file in user home

				emptyListCheck #Runs the function to ensure matching procs exist
		
				#Prints matching results
				echo -e "\nMatching processes: "
				ps -A | grep $search
		
				#Requests an argument from the user
				echo -ne "\nPlease enter the exact name of the process you wish to kill: "
				read -e argProc
				echo

		else
			emptyListCheck
		fi
}


cleanUp #Ensures that the temporary files are nonexistent


#Verifies that the correct number of args has been entered
if [ "$#" == 1 ]; then
		argProc=$1
		procFileInit #
elif [ "$#" == 0 ]
		echo "ERROR: This script must be run with exactly 0 or 1 arguments."
		exit 10
fi

procSearch

#Requests process name or 
echo -ne "Please enter the exact name of the process you wish to kill or press return to search: "
read -e argProc


argProc=$(echo $argProc | cut -b1-15) #truncates to first 15 bytes for exact match


#Kills processes, request privilege escalation if necessary
if [ ! -z "$(ps -u root | grep $argProc)" ]; then
		echo "Root privileges required."
		sudo xargs kill < ~/.nkpidlist
else
		xargs kill < ~/.nkpidlist
fi

echo


cleanUp
