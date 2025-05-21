#!/usr/bin/sh

# This script manages the compression and decompression of folders with docker volumes for portability.
# It compresses the contents of the specified folders into a tar.xz file, and decompresses it back to its original state.
# The script uses 'tar' for compression and decompression.
# Note: The script assumes that the folders are located in the current working directory.
# Note: The script must be run with root privileges.

# Usage:
# ./manage-volumes.sh compress
# ./manage-volumes.sh decompress

# Check if the script is run with root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {compress|decompress}"
    exit 1
fi


# Define the folders to be compressed/decompressed
FOLDERS=("db_data" "joomla_data")
EXTENSION="tar.xz"

case "$1" in
    compress)
        for folder in "${FOLDERS[@]}"; do
            if [ ! -d "$folder" ]; then
                echo "Folder $folder does not exist."
                exit 1
            fi

            # Compress the folders into a tar.xz file
            tar -cpJf "${folder}.${EXTENSION}" "${folder}"
        done
        echo "Folders compressed"
        ;;
    decompress)
        tar -xpJf "${FOLDERS[0]}.${EXTENSION}"
        tar -xpJf "${FOLDERS[1]}.${EXTENSION}"
        echo "Folders decompressed"
        ;;
    *)
        echo "Invalid argument. Use 'compress' or 'decompress'."
        exit 1
        ;;
esac
