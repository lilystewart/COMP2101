#!/bin/bash
#
# This script implements a guessing game
# it will pick a secret number from 1 to 10
# it will then repeatedly ask the user to guess the number
#    until the user gets it right

# Give the user instructions for the game
cat <<EOF
Let's play a game.
I will pick a secret number from 1 to 10 and you have to guess it.
If you get it right, you get a virtual prize.
Here we go!

EOF

# Pick the secret number and save it
secretnumber=$(($RANDOM % 10 +1)) # save our secret number to compare later
echo $secretnumber  # for testing purposes
# This loop repeatedly asks the user to guess and tells them if they got the right answer
# TASK 1: Test the user input to make sure it is not blank
# TASK 2: Test the user input to make sure it is a number from 1 to 10 inclusive
# TASK 3: Tell the user if their guess is too low, or too high after each incorrect guess
read -p "Give me a number from 1 to 10: " userguess # ask for a guess

while [ -z $userguess ]; do
  read -p "You did not enter a number. Please enter a number from 1 to 10: " userguess
    #if [[ $userguess -lt 1 ]]; then
      #read -p "You did not enter a number between 1 and 10. Please do so now: " userguess
    #elif [[ $userguess -gt 10 ]]; then
      #read -p "You did not enter a number between 1 and 10. Please do so now: " userguess
    #fi
done

#while [[ $userguess -lt 1 || $userguess -gt 1 ]]; do
  #read -p "You did not enter a number between 1 and 10. Please do so now: " userguess
#done

while [ $userguess != $secretnumber ]; do

#while [ -z $userguess ]; do
  #read -p "You did not enter a number. Please enter a number from 1 to 10: "
#done
      if [ $userguess -lt $secretnumber ]; then
        echo "Your number guess is too low."
        read -p "Try again: " userguess
      elif [ $userguess -gt $secretnumber ]; then
        echo "Your number guess is too high."
        read -p  "Try again: " userguess
      elif [ $userguess -lt 1 ]; then
        echo "Your number guess is out of range."
        read -p "Please give a number between 1 and 10: "
      elif [ $userguess -gt 10 ]; then
        echo "Your number guess is out of range."
        read -p "Please give a number between 1 and 10: "
      fi
      #while [[ -z $userguess ]]; do
        #read -p "You did not enter a number. Please enter a number from 1 to 10: "
      #done
done
echo "You guess correctly! Here is a virtual \$20 prize!"
