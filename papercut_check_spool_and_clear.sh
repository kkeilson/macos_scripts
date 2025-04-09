#!/bin/bash
# Script to check and clear PaperCut and CUPS spool space
# This script checks the disk usage of the PaperCut and CUPS spool directories
# and clears the spool space if the usage exceeds a specified threshold.

# Ensure the script is run with sudo privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please use sudo to execute it."
    exit 1
fi

# Define the spool directories for PaperCut and CUPS
PAPERCUT_SPOOL_DIR="/var/spool/papercut/"
CUPS_SPOOL_DIR="/var/spool/cups"

# Define the threshold for low disk space (in percentage)
THRESHOLD=90

# Define the log file
LOG_FILE="/var/log/spool_space_check.log"

# Ensure the log file exists and is writable
touch "$LOG_FILE" || { echo "Failed to create log file: $LOG_FILE"; exit 1; }

# Function to log messages
log_message() {
    local message
    message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOG_FILE"
}

# Function to check and clear spool space
check_and_clear_spool() {
    local dir
    dir=$1
    local usage
    usage=$(df "$dir" | awk 'NR==2 {print $5}' | sed 's/%//')

    log_message "Checking disk usage for $dir..."
    if [ "$usage" -ge "$THRESHOLD" ]; then
        log_message "Disk usage for $dir is at $usage%, which is above the threshold of $THRESHOLD%."
        log_message "Clearing spool space in $dir..."
        if rm -rf "${dir:?}"/*; then
            log_message "Spool space cleared for $dir."
        else
            log_message "Failed to clear spool space for $dir."
        fi
    else
        log_message "Disk usage for $dir is at $usage%, which is below the threshold of $THRESHOLD%. No action needed."
    fi
}

# Check and clear PaperCut spool space
if [ -d "$PAPERCUT_SPOOL_DIR" ]; then
    check_and_clear_spool "$PAPERCUT_SPOOL_DIR"
else
    log_message "PaperCut spool directory $PAPERCUT_SPOOL_DIR does not exist. Skipping..."
fi

# Check and clear CUPS spool space
if [ -d "$CUPS_SPOOL_DIR" ]; then
    check_and_clear_spool "$CUPS_SPOOL_DIR"
else
    log_message "CUPS spool directory $CUPS_SPOOL_DIR does not exist. Skipping..."
fi

log_message "Spool space check and cleanup completed."