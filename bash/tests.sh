#!/bin/bash
# This is a script to practice doing testing in bash scripts

# This section demonstrates file testing
echo ""
echo "Information on resolv.conf File"
echo "==============================="
# Test for the existence of the /etc/resolv.conf file
test -e /etc/resolv.conf && echo "/etc/resolv.conf exists" || echo "/etc/resolv.conf does not exist"
# TASK 1: Add a test to see if the /etc/resolv.conf file is a regular file
test -f /etc/resolv.conf && echo "/etc/resolv.conf is a regular file." || echo "/etc/resolv.conf is not a regular file."
# TASK 2: Add a test to see if the /etc/resolv.conf file is a symbolic link
test -h /etc/resolv.conf && echo "/etc/resolv.conf is a symbolic link." || echo "/etc/resolv.conf is not a symbolic link."
# TASK 3: Add a test to see if the /etc/resolv.conf file is a directory
test -d /etc/resolv.conf && echo "/etc/resolv.conf is a directory." || echo "/etc/resolv.conf is not a directory."
# TASK 4: Add a test to see if the /etc/resolv.conf file is readable
test -r /etc/resolv.conf && echo "/etc/resolv.conf if a readable file." || echo "/etc/resolv.conf is not a readable file."
# TASK 5: Add a test to see if the /etc/resolv.conf file is writable
test -w /etc/resolv.conf && echo "/etc/resolv.conf if a writable file." || echo "/etc/resolv.conf is not a writable file."
# TASK 6: Add a test to see if the /etc/resolv.conf file is executable
test -x /etc/resolv.conf && echo "/etc/resolv.conf is executable." || echo "/etc/resolv.conf is not executable."
echo ""

echo "Informaton on /tmp"
echo "=================="
# Tests if /tmp is a directory
# TASK 4: Add a test to see if the /tmp directory is readable
[ -d /tmp ] && echo "/tmp is a directory" || echo "/tmp is not a directory"
# TASK 5: Add a test to see if the /tmp directory is writable
[ -w /tmp ] && echo "/tmp directory is writable." || echo "/tmp directory is not writable."
# TASK 6: Add a test to see if the /tmp directory can be accessed
[ -x /tmp ] && echo "/tmp directory can be accessed." || echo "/tmp directory cannot be accessed."
echo ""

# Tests if one file is newer than another
echo "Which file is newer: resolv.conf or hosts?"
echo "==========================================="
# TASK 7: Add testing to print out which file newest, or if they are the same age
[ /etc/hosts -nt /etc/resolv.conf ] && echo "/etc/hosts is newer than /etc/resolv.conf"
[ /etc/hosts -ot /etc/resolv.conf ] && echo "/etc/resolv.conf is newer than /etc/hosts"
[ ! /etc/hosts -nt /etc/resolv.conf -a ! /etc/hosts -ot /etc/resolv.conf ] && echo "/etc/hosts is the same age as /etc/resolv.conf"
echo ""
# this section demonstrates doing numeric tests in bash
echo "Bash Numeric Tests"
echo "=================="
# TASK 1: Improve it by getting the user to give us the numbers to use in our tests

prompt="Please choose a number: "
read -p "$prompt" firstNumber
prompt="Please choose a second number: "
read -p "$prompt" secondNumber

[ $firstNumber -eq $secondNumber ] && echo "The two numbers are the same"
[ $firstNumber -ne $secondNumber ] && echo "The two numbers are not the same"

[ $firstNumber -lt $secondNumber ] && echo "The first number is less than the second number"
[ $firstNumber -gt $secondNumber ] && echo "The first number is greater than the second number"

[ $firstNumber -le $secondNumber ] && echo "The first number is less than or equal to the second number"
[ $firstNumber -ge $secondNumber ] && echo "The first number is greater than or equal to the second number"

# TASK 2: Improve it by adding a test to tell the user if the numbers are even or odd
if (($firstNumber%2 == 0)); then
  echo "The first number is even."
else
  echo "The first number is odd."
fi

if (($secondNumber%2 == 0)); then
  echo "The second number is even."
else
  echo "The second number is odd."
fi

# TASK 3: Improve it by adding a test to tell the user is the second number is a multiple of the first number
if (($secondNumber/$firstNumber==0)); then
  echo "The second number is a multiple of the first number."
else
  echo "The second number is not a multiple of the first number."
fi
echo ""

# This section demonstrates testing variables
echo "Testing Variables"
echo "================="
# Test if the USER variable exists
[ -v USER ] && echo "The variable SHELL exists"
# TASK 1: Add a command that prints out a labelled description of what is in the USER variable, but only if it is not empty
[ -n USER ] && echo "Your user name is $USER."
# TASK 2: Add a command that tells the user if the USER variable exists, but is empty
[ -z USER ] && echo "This USER variable exists but is empty."
echo ""

# Tests for string data
# TASK 3: Modify the command to use the != operator instead of the = operator, without breaking the logic of the command
# TASK 4: Use the read command to ask the user running the script to give us strings to use for the tests
echo "String Data Tests"
echo "================="
prompt="Please enter a string: "
read -p "$prompt" a
prompt="Please enter a second string: "
read -p "$prompt" b

[ $a != $b ] && echo "$a is not alphanumerically equal to $b" || echo "$a is alphanumerically equal to $b"
