#!/bin/bash

# Function to display the tree-like list of disk devices
function show_disk_tree() {
    echo "Available Disk Devices:"
    lsblk --nodeps -o NAME,TYPE,SIZE,MOUNTPOINT | awk '/disk/ {print $1 " (" $2 ") - " $3 " - " $4}'
}

# Function to get user input for disk selection
function get_user_input() {
    read -p "Enter the number of the disk device you want to select: " selection
    selected_device=$(lsblk --nodeps -o NAME | awk "/^$selection\$/ {print}")
}

# Main script starts here
show_disk_tree
get_user_input

# Check if the selected_device variable is empty (invalid input) or not
if [[ -z $selected_device ]]; then
    echo "Invalid input or device not found. Exiting..."
    exit 1
else
    echo "Selected device: $selected_device"
fi

exit

export WK_DISK_DEV=nvme0n1; \
date; \
dd if=/dev/$WK_DISK_DEV bs=100M | tee >(openssl md5 > create.md5) | pv --name before-compress --cursor | zstd --fast --threads=0 | pv --name after-compress --cursor > $WK_DISK_DEV.dd.zst; \
date; \
zstdcat --threads=0 $WK_DISK_DEV.dd.zst | pv --name verifying --cursor | md5sum > verify.md5; \
cat create.md5; \
cat verify.md5; \
date