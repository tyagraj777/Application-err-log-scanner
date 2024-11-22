# Application-err-log-scanner

script that identifies the last two generated log files from /var/log/syslog and /var/log/messages, scans them for 25 common error markers, and saves a report with a timestamp

Dependency package needed

zip. use (sudo apt install zip)


Explanation:

* Log Files: The script identifies the most recent log files from /var/log/syslog and /var/log/messages by their modification time.

* Error Markers: It checks for 25 predefined error markers within the identified log files.

* Summary: It generates a detailed summary of any issues found, including the number of occurrences of each error.

* Zipped Output: The results are saved as a timestamped .zip file for easy access and further review.


* Usage:

1. Save the script to a file (e.g., scan_logs.sh).
2. Make it executable: chmod +x scan_logs.sh
3. Run the script: ./scan_logs.sh
4. You will be prompted for the number of log files to scan (default is 2).
5. The results will be saved in a .zip file with a timestamp.

