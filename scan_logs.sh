# Script that identifies the last two generated log files from /var/log/syslog and /var/log/messages, scans them for 25 common error markers, and saves a report with a timestamp

# Option to change the no of log files to scan

# for detail usage refer README file


#!/bin/bash

# Define error markers
ERROR_MARKERS=(
    "Segmentation Fault"
    "Permission Denied"
    "Out of Memory"
    "File Not Found"
    "Connection Refused"
    "Timeout Error"
    "Invalid Argument"
    "Null Pointer Exception"
    "Resource Exhausted"
    "Disk Full"
    "Segfault"
    "Command Not Found"
    "Unable to Open File"
    "Access Denied"
    "Database Connection Failed"
    "Cannot Allocate Memory"
    "Unreachable Network"
    "System Call Failed"
    "Memory Leak"
    "Stack Overflow"
    "File Lock Error"
    "Unexpected EOF"
    "Failed to Bind"
    "Service Unavailable"
    "Invalid Configuration"
)

# Default number of logs to scan
NUM_LOG_FILES=2
LOG_DIRS=("/var/log/syslog" "/var/log/messages")

# Function to find the last N log files by date
find_log_files() {
    LOG_FILES=()
    for LOG_DIR in "${LOG_DIRS[@]}"; do
        if [[ -f "$LOG_DIR" ]]; then
            LOG_FILES+=("$LOG_DIR")
        fi
    done

    # Sort log files by date, keeping the last N files
    LOG_FILES=($(ls -lt ${LOG_FILES[@]} | head -n $NUM_LOG_FILES))
}

# Function to scan logs for error markers
scan_logs() {
    OUTPUT_FILE="error_summary_$(date +%Y%m%d_%H%M%S).txt"
    touch "$OUTPUT_FILE"

    echo "Scanning the last $NUM_LOG_FILES logs for error markers..." >> "$OUTPUT_FILE"

    for LOG_FILE in "${LOG_FILES[@]}"; do
        echo "Scanning $LOG_FILE..." >> "$OUTPUT_FILE"
        for marker in "${ERROR_MARKERS[@]}"; do
            COUNT=$(grep -i "$marker" "$LOG_FILE" | wc -l)
            if [[ $COUNT -gt 0 ]]; then
                echo "$marker: $COUNT occurrences in $LOG_FILE" >> "$OUTPUT_FILE"
                echo "Possible issue: $(echo $marker | sed 's/ /_/g')" >> "$OUTPUT_FILE"
            fi
        done
    done

    # Compress and save the report
    zip "${OUTPUT_FILE}.zip" "$OUTPUT_FILE"
    rm "$OUTPUT_FILE"
    echo "Results saved to ${OUTPUT_FILE}.zip"
}

# Get user input for the number of log files to scan
read -p "Enter number of log files to scan (default 2): " input_files
if [[ -n "$input_files" && "$input_files" -gt 0 ]]; then
    NUM_LOG_FILES=$input_files
fi

# Find the latest N log files by date
find_log_files

# Scan logs and generate the report
scan_logs
