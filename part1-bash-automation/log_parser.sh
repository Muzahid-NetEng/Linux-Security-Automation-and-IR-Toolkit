#!/bin/bash
# ==========================================================
# Script Name: log_parser.sh
# Description: Parses SSH logs for brute-force attacks and
#              generates/applies firewall blocking rules.
# Author: Md Muzahidul Islam
# ==========================================================

LOG_FILE="${1:-reports/sample_auth.log}"
THRESHOLD=3

echo "=========================================="
echo "   SSH BRUTE-FORCE LOG PARSER & BLOCKER   "
echo "   Target Log: $LOG_FILE"
echo "   Date: $(date)"
echo "=========================================="

if [[ ! -f "$LOG_FILE" ]]; then
    echo "[-] Error: Log file $LOG_FILE not found!"
    exit 1
fi

echo -e "\n[+] Scanning for Failed SSH Login Attempts (Threshold: >$THRESHOLD)..."

grep "Failed password" "$LOG_FILE" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort | uniq -c | while read count ip; do
    if [ "$count" -gt "$THRESHOLD" ]; then
        echo "  [!] ALERT: Brute-force detected from IP: $ip ($count failed attempts)"
        echo "  [>] Action: Blocking $ip via UFW/Iptables..."
        # Real firewall command (uncomment in production):
        # sudo ufw deny from $ip to any
        echo "  [+] Simulated Rule Applied: sudo iptables -A INPUT -s $ip -j DROP"
    else
        echo "  [i] Normal activity from IP: $ip ($count failed attempts)"
    fi
done

echo -e "\n=========================================="
echo "   Log Analysis Completed!"
echo "=========================================="

