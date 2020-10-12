#!/bin/bash
#
# This script produces a dynamic welcome message
# it should look like
#   Welcome to planet hostname, title name!

# Task 1: Use the variable $USER instead of the myname variable to get your name


# Task 2: Dynamically generate the value for your hostname variable using the hostname command - e.g. $(hostname)
# Task 3: Add the time and day of the week to the welcome message using the format shown below
#   Use a format like this:
#   It is weekday at HH:MM AM.
# Task 4: Set the title using the day of the week
#   e.g. On Monday it might be Optimist, Tuesday might be Realist, Wednesday might be Pessimist, etc.
#   You will need multiple tests to set a title
#   Invent your own titles, do not use the ones from this example

###############
# Variables   #
###############
myname=$USER
hostname=$HOSTNAME
day=$(date +%A)
time=$(date +%T" "%p)
#if statement for different titles depending on the day of the week. Added daymessages for fun.
title=""
daymsg=""
if [ $day == "Monday" ]; then
  title="Moody"
  daymsg="You look like you need an extra coffee today."
elif [ $day == "Tuesday" ]; then
  title="Chirpy"
  daymsg="Well you look ready to do some work!"
elif [ $day == "Wednesday" ]; then
  daymsg="There is lots to do today! Roll up those sleeves."
  title="Ambitious"
elif [ $day == "Thursday" ]; then
  title="Grumpy"
  daymsg="You look a little worn out. Hang in there!"
elif [ $day == "Friday" ]; then
  title="Joyful"
  daymsg="You made it to the end of the week and no one is hurt!!"
elif [ $day == "Saturday" ]; then
  title="Overachiever"
  daymsg="Shouldn't you be sleeping in and enjoying the day?"
else
  title="Workaholic"
  daymsg="Seriously.... why are you here?"
fi
###############
# Main        #
###############
welcome="Welcome to Planet $hostname, $title $myname!
It is $day at $time.
$daymsg."
echo $welcome|cowsay
