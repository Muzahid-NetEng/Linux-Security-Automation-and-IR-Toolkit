#!/bin/bash
# ==========================================================
# Script Name: cron_hunter.sh
# Description: Hunts for malicious cronjob persistence and
#              unauthorized reverse-shell scheduled tasks.
# Author: Md Muzahidul Islam
# ==========================================================

SAMPLE_CRON="${1:-reports/sample_crontab.txt}"
SUSPICIOUS_PATTERNS="nc |netcat|/dev/tcp|bash -i|curl.*sh|wget.*sh|python.*socket|base64 -d"

echo "=========================================="
echo "   CRONJOB BACKDOOR & PERSISTENCE HUNTER  "
echo "   Date: $(date)"
echo "=========================================="

echo -e "\n[+] 1. Auditing System Crontab (/etc/crontab):"
if [[ -f /etc/crontab ]]; then
    grep -v "^#" /etc/crontab | grep -v "^$" | sed 's/^/  -> /'
else
    echo "  [i] /etc/crontab not found."
fi

echo -e "\n[+] 2. Scanning /etc/cron.d/ and System Cron Directories:"
ls -la /etc/cron.d/ /etc/cron.daily/ 2>/dev/null | grep -E "^-" | awk '{print "  -> File:", $9}'

echo -e "\n[+] 3. Checking Current User Crontab ($USER):"
crontab -l 2>/dev/null || echo "  [i] No active user crontab entries for $USER."

echo -e "\n[+] 4. Hunting Malicious Patterns in Target Cron ($SAMPLE_CRON):"
if [[ -f "$SAMPLE_CRON" ]]; then
    grep -E "$SUSPICIOUS_PATTERNS" "$SAMPLE_CRON" | while read -r line; do
        echo "  [!] ALERT: Suspicious Persistence Found -> $line"
    done
else
    echo "  [-] Target cron file $SAMPLE_CRON not found!"
fi

echo -e "\n=========================================="
echo "   Cronjob Persistence Hunt Completed!    "
echo "=========================================="
