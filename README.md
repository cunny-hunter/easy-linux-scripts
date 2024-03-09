# easy-linux-scripts
Ease of life scripts for Linux (i use arch btw) that I made in my free time. (work in progress, i will keep adding stuff occasionally)
    
1. LUKS Mounting Script (mount_drives.sh)
    
    This reads from the 'crypt_drives.txt' file and mounts the drives. The script assumes all drives use the same password. Set it to launch at startup to have the password prompt appear automatically.
    
    The script probably might seem quite unnessary, but its useful when, for example, once in a blue moon, you start up the computer and feel like not mounting your encrypted drives.
    
    Using something like crypttab to mount it automatically might be convenient, but what if you're lending your computer or smth and you forget to remove your crypttab entries?
    
2. Firefox History Clear after Shutdown/Restart (firefox-delete.sh)
    
    If you shut down/restart the system without manually quitting firefox first (only in linux), it restores your last open tabs regardless of if you have that setting disabled or not.
    This happens because (what i assume) firefox not catching the SIGTERM signal sent by the kernel, and abruptly closing, resulting in it re-opening the last opened tabs as it would if it crashed.
