#!/bin/bash

cryptsetup_file="./crypt_drives.txt"

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root..."
  exit 1
fi

function cryptsetup_luks() {
  local device="$1"
  local name="$2"
  local password="$3"
  
  echo "$password" | cryptsetup luksOpen "$device" "$name"
  return $?
}

if pacman -Qi zenity; then
    if [ -f "$cryptsetup_file" ] || [ -s "$cryptsetup_file" ]; then
        while true; do
            password=$(zenity --password --title="Enter Password" --text="Please enter your password:")
            if [ $? -ne 0 ]; then
                echo -e "\nPassword entry canceled.\n"
                exit 1
            elif [ -n "$password" ]; then
                while IFS= read -r line || [ -n "$line" ]; do
                    # Skip empty lines
                    if [[ -n "$line" ]]; then
                        # Extract device and name from the line
                        device=$(echo "$line" | awk '{print $1}')
                        name=$(echo "$line" | awk '{print $2}')
                        # Call the function to open the LUKS-encrypted drive and,
                        # Check the return value of the function
                        cryptsetup_luks "$device" "$name" "$password"
                        if [ $? -eq 0 ]; then
                            # If successful, mount the drive
                            mount --mkdir "/dev/mapper/$name" "/mnt/$name"
                            echo "Encrypted drive '$name' mounted successfully."
                            echo "Mount command executed with exit code: $?"
                        else
                            echo "Error opening LUKS-encrypted drive '$name'."
                        fi
                    else
                        echo -e "\nEmpty lines in config file or some other error. Please check the config file...\n"
                        exit 1
                    fi
                done < "$cryptsetup_file"
                
                zenity --info --title="Process has finished!" --text="All drives (or none of them) have been successfully mounted."
                exit 0

            elif [ "$password" == "" ]; then
                zenity --error --title="No password provided!" --text="A password is required to mount your drives. Please try again."
            else
                zenity --error --title="Disk mount failed!" --text="Incorrect Password or some other error. Please try again."
            fi
        done
    else
        zenity --error --title="Config file is empty!" --text="The file containing the config does not exist or is empty! Please populate it and try again!"
        exit 1
    fi
else
    echo -e "\nPlease install 'zenity' or modify the script to work without it.../n"
    exit 1
fi
