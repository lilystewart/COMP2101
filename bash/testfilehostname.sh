#!/bin/bash

#testfile prior to testing it through production

currenthost=$(hostname)
echo "Your current hostname is $currenthost."

read -p "Please enter your student number: " studentnum
newhostname=pc$studentnum
echo "Your new hostname is going to be $newhostname."

# find currenthost name and replace with newhostname in testfile, write changes to changes.txt
sed -i "s/$currenthost/$newhostname/w changes.txt" testfile
if [ -s changes.txt ]; then
  echo "Changed hostn from: $currenthost to: $newhostname."
  #hostnamectl set-hostname $newhostname
  echo "Please reboot your PC now to save changes."
else
  echo "No changes made."
fi

rm changes.txt  
