#!/bin/bash

# Function to display script usage
usage() {
    echo "Usage: $0 [-h]"
    echo "Automated Raspberry Pi Setup Script"
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this help message and exit"
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Invalid option: $1"
            echo ""
            usage
            exit 1
            ;;
    esac
    shift
done

# Set up variables
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
report="setup_report.txt"

# Nanorc configuration
nanorc_config="set linenumbers
set tabsize 2
set mouse
include \"/usr/share/nano/*.nanorc\""

# Tmux configuration
tmux_config="# Enable mouse support
set -g mouse on"

# Create or update the nanorc file
echo "$nanorc_config" > ~/.nanorc

# Create or update the tmux.conf file
echo "$tmux_config" > ~/.tmux.conf

# Store the commands and step names in an array
declare -a steps=(
  "apt update"
  "DEBIAN_FRONTEND=noninteractive apt upgrade -y"
  "DEBIAN_FRONTEND=noninteractive apt full-upgrade -y"
	"DEBIAN_FRONTEND=noninteractive apt autoremove -y"
  "echo 'deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware' > /etc/apt/sources.list"
  "echo 'deb http://security.debian.org/debian-security bookworm-security main contrib non-free' >> /etc/apt/sources.list"
  "echo 'deb http://deb.debian.org/debian bookworm-updates main contrib non-free' >> /etc/apt/sources.list"
  "echo 'deb http://archive.raspberrypi.org/debian/ bookworm main' > /etc/apt/sources.list.d/raspi.list"
  "apt update"
  "DEBIAN_FRONTEND=noninteractive apt upgrade -y"
  "DEBIAN_FRONTEND=noninteractive apt full-upgrade -y"
	"DEBIAN_FRONTEND=noninteractive apt autoremove -y"
  "DEBIAN_FRONTEND=noninteractive apt install git golang tmux nano rsync -y"
)

# Create a function to check the success/failure of each step
check_status() {
  if [ $? -eq 0 ]; then
    echo "✅ Step ${step_num}: ${step_name}: successful" >> "$report"
  else
    echo "❌ Step ${step_num}: ${step_name}: failed" >> "$report"
  fi
}

# Create the setup report
touch "$report"
echo "=== Setup Report - $(hostname) ===" > "$report"
echo "Timestamp: $timestamp" >> "$report"

# Run the steps and update the setup report
for ((step_num=0; step_num<${#steps[@]}; step_num++)); do
  step_name="${steps[$step_num]}"
  echo -e "\n\n==============================\nRunning Step $((step_num+1)): $step_name...\n==============================\n\n"
  eval "$step_name"
  check_status
done

# Display the report
cat "$report"
