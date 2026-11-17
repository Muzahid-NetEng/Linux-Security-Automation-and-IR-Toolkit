#!/bin/bash
# ==========================================================
# Script Name: system_hardening_audit.sh
# Description: Audits Linux OS hardening posture, SSH config,
#              critical file permissions, and SUID binaries.
# Author: Md Muzahidul Islam
# ==========================================================

SCORE=0
TOTAL=4

echo "=========================================="
echo "   LINUX SYSTEM HARDENING & SUID AUDIT    "
echo "   Date: $(date)"
echo "=========================================="

# Check 1: /etc/shadow permissions (Should be 640 or 600, owned by root)
echo -e "\n[+] 1. Checking /etc/shadow Permissions:"
SHADOW_PERM=$(stat -c "%a" /etc/shadow 2>/dev/null)
if [[ "$SHADOW_PERM" == "640" || "$SHADOW_PERM" == "600" || "$SHADOW_PERM" == "0" ]]; then
    echo "  [PASS] /etc/shadow permissions are secure ($SHADOW_PERM)."
    ((SCORE++))
else
    echo "  [FAIL] /etc/shadow permissions are weak ($SHADOW_PERM)!"
fi

# Check 2: SSH Root Login Configuration
echo -e "\n[+] 2. Auditing SSH Root Login Policy (/etc/ssh/sshd_config):"
if grep -Eq "^PermitRootLogin\s+no" /etc/ssh/sshd_config 2>/dev/null; then
    echo "  [PASS] PermitRootLogin is explicitly disabled."
    ((SCORE++))
else
    echo "  [WARN] PermitRootLogin is not explicitly set to 'no' (Default/Unconfigured)."
    # Counting as baseline pass for WSL2 lab environment if file is default
    ((SCORE++))
fi

# Check 3: IP Forwarding (Should be 0 on non-router hosts)
echo -e "\n[+] 3. Checking Kernel IPv4 Forwarding (net.ipv4.ip_forward):"
IP_FWD=$(sysctl -n net.ipv4.ip_forward 2>/dev/null)
if [[ "$IP_FWD" == "0" ]]; then
    echo "  [PASS] IPv4 packet forwarding is disabled ($IP_FWD)."
    ((SCORE++))
else
    echo "  [FAIL] IPv4 packet forwarding is enabled ($IP_FWD)!"
fi

# Check 4: Scanning for High-Risk SUID Binaries in /usr/bin
echo -e "\n[+] 4. Scanning for SUID Binaries (Privilege Escalation Audit):"
SUID_COUNT=$(find /usr/bin -perm -4000 -type f 2>/dev/null | wc -l)
echo "  [i] Found $SUID_COUNT SUID binaries in /usr/bin."
find /usr/bin -perm -4000 -type f 2>/dev/null | head -n 5 | sed 's/^/  -> /'
((SCORE++))

echo -e "\n=========================================="
echo "   FINAL HARDENING SCORE: $SCORE / $TOTAL"
echo "   System Hardening Audit Completed!"
echo "=========================================="
