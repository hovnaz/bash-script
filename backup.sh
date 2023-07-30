#!/bin/bash

# Function to create a backup for a user's home directory
function backup_user_home() {
    local user="$1"
    local backup_parent_dir="/var/backups/$(date +'%Y_%m_%d')"
    local user_backup_dir="$backup_parent_dir/$user"
    local backup_name="backupName"

    if [ -d "/home/$user" ]; then
        mkdir -p "$user_backup_dir"
        chown -R "$user" "$user_backup_dir"

        local backup_file="$user_backup_dir/${backup_name}_$(date +'%Y_%m_%d').tar.gz.gpg"

        # Use --batch and --passphrase options with gpg for non-interactive passphrase input
        BACKUP_PASSWORD=$(grep '^BACKUP_PASSWORD=' /etc/credentials.conf | cut -d '=' -f2)
	tar czf -C "/home" "$user" | gpg --batch --symmetric --cipher-algo AES256 --passphrase "$BACKUP_PASSWORD" > "$backup_file"

        echo "Backup for user $user completed: $backup_file"
    else
        echo "User $user does not have a home directory. Skipping..."
    fi
}

# Backup destination directory with format backup_YYYY_MM_DD
backup_dir="/var/backups/$(date +'%Y_%m_%d')"

# Get a list of all user directories in /home
user_dirs=$(ls -1 /home)

# Loop through each user directory and create a backup
for user in $user_dirs; do
    backup_user_home "$user"
done

# Optional: You can add a message to indicate the completion of the entire backup process
echo "Daily backup for all users completed."

