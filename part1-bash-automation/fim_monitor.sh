#!/bin/bash
# ==========================================================
# Script Name: fim_monitor.sh
# Description: SHA-256 File Integrity Monitoring (FIM) tool
#              to detect unauthorized file modifications.
# Author: Md Muzahidul Islam
# ==========================================================

TARGET_DIR="${1:-test_critical_files}"
BASELINE_FILE="reports/fim_baseline.sha256"

echo "=========================================="
echo "   SHA-256 FILE INTEGRITY MONITOR (FIM)   "
echo "   Target Directory: $TARGET_DIR"
echo "   Date: $(date)"
echo "=========================================="

if [[ "$2" == "--init" ]]; then
    echo -e "\n[+] Generating new SHA-256 baseline..."
    find "$TARGET_DIR" -type f -exec sha256sum {} + > "$BASELINE_FILE"
    echo "[+] Baseline saved to $BASELINE_FILE"
    cat "$BASELINE_FILE"
    exit 0
fi

if [[ ! -f "$BASELINE_FILE" ]]; then
    echo "[-] Baseline not found! Run with '--init' first."
    exit 1
fi

echo -e "\n[+] Verifying file integrity against baseline...\n"
sha256sum -c "$BASELINE_FILE"
STATUS=$?

echo -e "\n=========================================="
if [ $STATUS -eq 0 ]; then
    echo "   [OK] All files intact. No tampering detected."
else
    echo "   [!] ALERT: File modification or tampering detected!"
fi
echo "=========================================="
