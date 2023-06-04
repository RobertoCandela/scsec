#!/bin/bash

function generate_passphrase() {
    local passphrase=$(openssl rand -base64 32)
    security add-generic-password -a "passphrase" -s "scsec" -w "$passphrase"
    echo "Passphrase generated and saved in macOS Keychain."
}

function encode() {
    local file="$1"
    local passphrase=$(security find-generic-password -a "passphrase" -s "scsec" -w)

    if [[ "$file" == *".enc" ]]; then
        echo "Skipping already encoded file: $file"
        return
    fi

    openssl enc -aes-256-cbc -salt -in "$file" -out "${file}.enc" -k "$passphrase"
    echo "Encoded file: ${file}.enc"
    echo "Encoding completed."

    rm "$file"
    echo "Source file deleted: $file"
}

function decode() {
    local file="$1"
    local passphrase=$(security find-generic-password -a "passphrase" -s "scsec" -w)

    if [[ "$file" != *".enc" ]]; then
        echo "Skipping non-encoded file: $file"
        return
    fi

    echo "Attempting to decode file: $file"
    echo "Passphrase: $passphrase"

    openssl enc -aes-256-cbc -d -in "$file" -out "${file%.enc}" -k "$passphrase"

    if [ $? -eq 0 ]; then
        echo "Decoding completed successfully."
        echo "Decoded file: ${file%.enc}"
        rm "$file"
        echo "Encoded file deleted: $file"
    else
        echo "Decoding failed."
        exit 1
    fi
}

function process_directory() {
    local directory="$1"

    for file in "$directory"/*; do
        if [ -f "$file" ]; then
            "$function_to_execute" "$file"
        elif [ -d "$file" ]; then
            process_directory "$file"
        fi
    done
}

if [ -z "$1" ]; then
    echo "Error: Specify a directory as a parameter."
    exit 1
fi

if [ -z "$2" ]; then
    echo "Error: Specify -E or -D as the second parameter."
    exit 1
fi

directory="$1"
if [ ! -d "$directory" ]; then
    echo "Error: Directory $directory does not exist."
    exit 1
fi

if [ "$2" = "-E" ]; then
    function_to_execute="encode"
elif [ "$2" = "-D" ]; then
    function_to_execute="decode"
else
    echo "Error: The second parameter must be -E or -D."
    exit 1
fi

passphrase=$(security find-generic-password -a "passphrase" -s "scsec" -w)
if [ -z "$passphrase" ]; then
    generate_passphrase
    passphrase=$(security find-generic-password -a "passphrase" -s "scsec" -w)
fi

process_directory "$directory"
