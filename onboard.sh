# Shell Scripting
# This script will read a CSV file that contains 20 new Linux users.
# This script will create each user on the server and add to an existing group called 'Developers'.
# The script will first check for the existence of the user in the system, before it will atempt to create the user.
# The user that is being created must also have a default home folder.
# Each user shold have a .ssh folder within its HOME  folder. If it does not exist, then it will be created.
# For each users ssh configuration, we will create an authorized_keys file and add the below public key.

#!/bin/bash
userfile=$(cat names.csv)
PASSWORD=password

# To ensure the user running this script has sudo priviledge
    if [ $(id -u) -eq 0 ]; then

# Reading the CSV file
    for user in $userfile;
    do
        echo $user
    if id "$user" &>/dev/null
    then
        echo "User Exist"
    else

# This will create a new user
        useradd -m -d /home/$user -s /bin/bash -g developers $user
        echo "New User Created"
        echo

# This will create an ssh folder in the new user home folder
        su - -c "mkdir ~/.ssh" $user
        echo ".ssh directory created for new user"
        echo

# We need set the new permission for the ssh dir
        su - -c "chmod 700 ~/.ssh" $user
        echo "user permission for the .ssh directory set"
        echo

# This will create an authorized-key file 
        su - -c "touch ~/.ssh/authorized_keys" $user
        echo "Authorized Key File Created"
        echo

# We need to sert permission for the key file
        su - -c "chmod 600 ~/.ssh/authorized keys" $user
        echo "user permission for the authorized key file set"
        echo

# We need to create an set public key for users in the server
        cp -R "/root/onboard/id_rsa.pub" "/home/$user/ .ssh/authorized_keys"
        echo "Copied the Public Key to New User Account on the Server"
        echo
        echo

        echo "USER CREATED" 

# Generate a password.
sudo echo -e "$PASSWORD\n$PASSWORD" | sudo passwd "$user"
sudo passwd -x 5 $user  
                fi
            done
        else
        echo "Only Admin Can Onboard A User"
        fi
