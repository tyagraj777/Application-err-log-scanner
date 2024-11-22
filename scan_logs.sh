# Script that identifies the last two generated log files from /var/log/syslog and /var/log/messages, scans them for 25 common error markers, and saves a report with a timestamp

# Option to change the no of log files to scan

# for detail usage refer README file


#!/bin/bash

# List of error markers
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

# Function to scan logs and generate summaries
scan_logs() {
    LOG_FILES=("/var/log/syslog" "/var/log/messages")
    OUTPUT_FILE="error_summary_$(date +%Y%m%d_%H%M%S).txt"
    
    # Loop through the log files
    for log_file in "${LOG_FILES[@]}"; do
        if [[ -f $log_file ]]; then
            echo "Scanning $log_file..." >> "$OUTPUT_FILE"
            for marker in "${ERROR_MARKERS[@]}"; do
                COUNT=$(grep -i "$marker" "$log_file" | wc -l)
                if [[ $COUNT -gt 0 ]]; then
                    echo "$marker: $COUNT occurrences" >> "$OUTPUT_FILE"
                    echo "Possible issue: $(echo $marker | sed 's/ /_/g')" >> "$OUTPUT_FILE"
                fi
            done
        else
            echo "$log_file not found, skipping." >> "$OUTPUT_FILE"
        fi
    done
    
    # Zipping the output file
    zip "${OUTPUT_FILE}.zip" "$OUTPUT_FILE"
    rm "$OUTPUT_FILE"
    echo "Results saved to ${OUTPUT_FILE}.zip"
}

# Run the function
scan_logs
