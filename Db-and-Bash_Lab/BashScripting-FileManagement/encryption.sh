#!/bin/bash

# ===========================================
# File Encryption-Decryption Script
# ===========================================
# Description:
# This script allows users to encrypt or decrypt a file using a password.
# It uses OpenSSL AES-256-CBC algorithm for secure encryption.
#
# Features:
# - Secure password input
# - Strong encryption algorithm (AES-256-CBC)
# - Encrypted output saved with .enc extension
# - Decrypted output saved with .dec extension
#
# Usage:
# ./file_secure.sh encrypt <file_path>
# ./file_secure.sh decrypt <encrypted_file_path>
#
# Dependencies:
# - OpenSSL must be installed
#
# ===========================================

# ----------------------------
# Function: Encrypt file
# ----------------------------
encrypt_file() {
    local input_file="$1"
    local output_file="${input_file}.enc"

    # Check if file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Error: File '$input_file' not found."
        exit 1
    fi

    # Prompt for password securely
    echo -n "Enter encryption password: "
    read -s password
    echo
    echo -n "Confirm password: "
    read -s confirm_password
    echo

    if [[ "$password" != "$confirm_password" ]]; then
        echo "Error: Passwords do not match."
        exit 1
    fi

    # Encrypt using OpenSSL with AES-256-CBC
    openssl enc -aes-256-cbc -salt -in "$input_file" -out "$output_file" -pass pass:"$password"

    if [[ $? -eq 0 ]]; then
        echo "Encryption successful. Encrypted file: $output_file"
    else
        echo "Encryption failed."
    fi
}

# ----------------------------
# Function: Decrypt file
# ----------------------------
decrypt_file() {
    local input_file="$1"
    local output_file="${input_file%.enc}.dec"

    # Check if file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Error: File '$input_file' not found."
        exit 1
    fi

    # Prompt for password securely
    echo -n "Enter decryption password: "
    read -s password
    echo

    # Decrypt using OpenSSL
    openssl enc -d -aes-256-cbc -in "$input_file" -out "$output_file" -pass pass:"$password"

    if [[ $? -eq 0 ]]; then
        echo "Decryption successful. Decrypted file: $output_file"
    else
        echo "Decryption failed. Incorrect password or corrupted file."
    fi
}

# ----------------------------
# Main logic
# ----------------------------
if [[ $# -ne 2 ]]; then
    echo "Usage:"
    echo "  $0 encrypt <file_path>"
    echo "  $0 decrypt <encrypted_file_path>"
    exit 1
fi

COMMAND="$1"
FILE="$2"

case "$COMMAND" in
    encrypt)
        encrypt_file "$FILE"
        ;;
    decrypt)
        decrypt_file "$FILE"
        ;;
    *)
        echo "Invalid command. Use 'encrypt' or 'decrypt'."
        exit 1
        ;;
esac
