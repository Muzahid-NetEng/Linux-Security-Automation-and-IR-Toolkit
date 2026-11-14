#!/bin/bash
# ==========================================================
# Script Name: user_audit.sh
# Description: Audits Linux user accounts, UID 0 privileges,
#              empty passwords, and sudo group members.
# Author: Md Muzahidul Islam
# ==========================================================

echo "=========================================="
echo "   LINUX USER & PRIVILEGE SECURITY AUDIT  "
echo "   Date: $(date)"
echo "=========================================="

echo -e "\n[+] 1. Checking for accounts with UID 0 (Root Privileges):"
awk -F: '($3 == 0) {print "  -> User:", $1, "| UID:", $3}' /etc/passwd

echo -e "\n[+] 2. Checking for accounts with empty passwords:"
sudo awk -F: '($2 == "" ) {print "  -> WARNING: Empty password for user:", $1}' /etc/shadow

echo -e "\n[+] 3. Checking members of the 'sudo' group:"
grep '^sudo:' /etc/group | awk -F: '{print "  -> Sudo Users:", $4}'

echo -e "\n[+] 4. Listing regular human users (UID >= 1000):"
awk -F: '($3 >= 1000 && $1 != "nobody") {print "  -> User:", $1, "| Home:", $6, "| Shell:", $7}' /etc/passwd

echo -e "\n=========================================="
echo "   Audit Completed Successfully!"
echo "=========================================="
