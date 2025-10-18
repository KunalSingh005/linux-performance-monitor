#!/bin/bash

# server-stats.sh
# A script to display key server performance statistics.
# Created for a DevOps learner to understand system monitoring.

# Define color codes for better readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print a formatted header
print_header() {
    echo -e "\n${YELLOW}=========================================${NC}"
    echo -e "${YELLOW}# $1${NC}"
    echo -e "${YELLOW}=========================================${NC}"
}

### 1. System Information (Stretch Goal) ###
print_header "System Information"
echo -e "Hostname:          $(hostname)"
echo -e "OS Version:        $(grep PRETTY_NAME /etc/os-release | cut -d'=' -f2 | tr -d '"')"
echo -e "Uptime:            $(uptime -p)"
echo -e "Load Average:      $(uptime | awk -F'load average:' '{ print $2 }' | sed 's/ //g')"
echo -e "Logged-in Users:   $(who | wc -l)"

### 2. CPU Usage ###
print_header "CPU Usage"
# Get the idle percentage and subtract it from 100 to get total usage
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
CPU_USAGE=$(echo "100.0 - $CPU_IDLE" | bc)
echo -e "Total CPU Usage:   ${GREEN}${CPU_USAGE}%${NC}"

### 3. Memory Usage ###
print_header "Memory Usage (Free vs Used)"
# Using 'free -h' for a human-readable summary
free -h
# Calculating a specific percentage summary
MEM_INFO=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2}')
echo -e "\nSummary:           ${GREEN}${MEM_INFO}%${NC} Used"

### 4. Disk Usage ###
print_header "Disk Usage (Free vs Used)"
# Using 'df -h' to show usage for all mounted filesystems
df -h

### 5. Top 5 Processes by CPU Usage ###
print_header "Top 5 Processes by CPU Usage"
ps -eo %cpu,pid,user,cmd --sort=-%cpu | head -n 6

### 6. Top 5 Processes by Memory Usage ###
print_header "Top 5 Processes by Memory Usage"
ps -eo %mem,pid,user,cmd --sort=-%mem | head -n 6

### 7. Failed Login Attempts (Stretch Goal) ###
print_header "Failed Login Attempts"
# The log file location can vary (e.g., /var/log/secure on CentOS/RHEL)
LOG_FILE="/var/log/auth.log"
if [ -f "$LOG_FILE" ]; then
    # Use '2>/dev/null' to suppress errors if we don't have read permission
    FAILED_COUNT=$(grep 'Failed password' "$LOG_FILE" 2>/dev/null | wc -l)
    echo "Failed logins found in '$LOG_FILE': ${GREEN}$FAILED_COUNT${NC}"
    echo "(Note: Accurate count may require 'sudo' permissions)"
else
    echo "Log file '$LOG_FILE' not found. Check /var/log/secure for CentOS/RHEL."
fi

echo -e "\n${YELLOW}=========================================${NC}"
echo -e "${YELLOW}# Analysis Complete${NC}"
echo -e "${YELLOW}=========================================${NC}"
# Section 0: System Information
echo "===== System Information ====="
echo "Hostname: $(hostname)"
echo "OS Version: $(grep PRETTY_NAME /etc/os-release | cut -d'=' -f2 | tr -d '"')"
echo "Uptime: $(uptime -p)"
echo "Load Average: $(uptime | awk -F'load average:' '{ print $2 }')"
echo "Logged-in Users: $(who | wc -l)"
echo ""
