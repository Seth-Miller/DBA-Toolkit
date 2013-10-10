#!/bin/sh

# Oracle Environment Menu
# Created by Seth Miller 2013/10
# Version 1.0


# This script is meant to replace the "oraenv" script that is the Oracle
# default environment setting script. This is especially useful in a RAC
# environment where an Oracle instance will require a proceeding number.




ORATAB=/etc/oratab
EGREP=/usr/bin/egrep

# Custom prompt
# Called to change the ORACLE_HOME and ORACLE_SID parameters in the prompt
function ps1 ()
{
export PS1="\n\[\033[35m\]\$(echo ORACLE_HOME=$1)\n$(echo ORACLE_SID=$2)\n\[\033[32m\]\w\n\[\033[1;31m\]\u@\h: \[\033[1;34m\]\$(/usr/bin/tty | /bin/sed -e 's:/dev/::'): \[\033[1;36m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files \[\033[1;33m\]\$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\033[0m\] -> \[\033[0m\]"
}

# Menu to change the ORACLE_HOME and ORACLE_SID and set the environment
# similar to what oraenv does
function db ()
{
# Set the prompt for the menu
PS3=$'\n''What would you like to set your ORACLE_SID parameter to? '

# Capture original PATH
if [ ! "$DEFPATH" ]; then
	DEFPATH="$PATH"
fi

# This number will be appended to the ORACLE_SID
# If this is not RAC, these two lines can be commented out
# Set the DEFRACNODE variable if you do not want to be prompted for this
if [ ! "$DEFRACNODE" ]; then
	echo "Type in the instance number: "
	read RACNODE
fi

# Retrieve all of the database names from ORATAB, ignoring any line that starts with ^, # or *
# Trim everything starting with the first colon
# Leave an option for manual entry of an ORACLE_SID and an ORACLE_HOME
# Assign the ORACLE_SID and ORACLE_HOME parameters
# If ASM is chosen, do not append the RACNODE to it
select VAR in $( $EGREP '^[^#*]*:' $ORATAB | cut -d ':' -f 1 | sort ) "Manual Input"; do
	case $VAR in
		"Manual Input")
		  echo
		  echo "Type in your SID"
		  read VAR2
		  export ORACLE_SID=$VAR2
		  echo "Type in your ORACLE_HOME"
		  read VAR2
		  export ORACLE_HOME=$VAR2
		  break
		  ;;
		"+ASM"*)
		  export ORACLE_SID=$VAR
		  # Variable manipulation is to turn "+ASM1" into "\+ASM1"
		  # because plus sign is a metacharacter in regexp
		  export ORACLE_HOME=$( $EGREP -m 1 "^${VAR/+/\\+}" $ORATAB | cut -d ":" -f 2 )
		  break
		  ;;
		*)
		  export ORACLE_SID=${VAR}${RACNODE}
		  export ORACLE_HOME=$( $EGREP -m 1 "^${VAR/+/\\+}" $ORATAB | cut -d ":" -f 2 )
		  break
		  ;;
	esac
done

# Include ORACLE_HOME executables in PATH
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:$DEFPATH

# Reset the prompt with current ORACLE_HOME and ORACLE_SID
ps1 $ORACLE_HOME $ORACLE_SID
}

