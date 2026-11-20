# Linux Security Automation & Incident Response Toolkit

![Platform](https://shields.io)
![Language](https://shields.io)
![Focus](https://shields.io)
![Author](https://shields.io)

A modular Bash-based security automation and defensive auditing toolkit designed for **SOC Analysts**, **Incident Responders**, and **Linux System Administrators**. This suite automates routine system hardening checks, authentication log analysis, file integrity verification, and scheduled task auditing.

---

## 📂 Repository Architecture

```text
Linux-Security-Automation-and-IR-Toolkit/
├── scripts/
│   ├── user_audit.sh               # Privileged account, UID 0, & shadow policy auditor
│   ├── log_parser.sh               # SSH brute-force & authentication anomaly parser
│   ├── fim_monitor.sh              # SHA-256 cryptographic File Integrity Monitor (FIM)
│   ├── cron_hunter.sh              # Scheduled task & cron persistence auditor
│   └── system_hardening_audit.sh   # Kernel sysctl, firewall, & SSH configuration baseline auditor
├── reports/                        # Generated Markdown & text audit reports (Proof of Concept)
└── README.md
```

---

## Core Modules & Capabilities

| Module | Primary Function | Key Defensive Checks |
| :--- | :--- | :--- |
| **`user_audit.sh`** | Identity & Access Audit | Detects unauthorized `UID 0` accounts, empty password fields in `/etc/shadow`, and `sudo` group privileges. |
| **`log_parser.sh`** | Authentication Log Triage | Parses `/var/log/auth.log` to identify SSH brute-force attempts, top attacking IPs, and invalid user logins. |
| **`fim_monitor.sh`** | File Integrity Monitoring | Establishes SHA-256 cryptographic baselines for critical binaries and `/etc` configs to detect tampering. |
| **`cron_hunter.sh`** | Scheduled Persistence Audit | Scans user crontabs, `/etc/crontab`, and `/etc/cron.*` directories for unauthorized scheduled payloads. |
| **`system_hardening_audit.sh`** | CIS Baseline & Hardening | Evaluates SSH daemon security (`PermitRootLogin`), UFW firewall status, and kernel network parameters. |

---

## Quick Start & Usage

1. **Clone the repository:**
   ```bash
   git clone https://github.com
   cd Linux-Security-Automation-and-IR-Toolkit
   ```

2. **Grant execution permissions:**
   ```bash
   chmod +x scripts/*.sh
   ```

3. **Execute any audit module (some checks require elevated privileges):**
   ```bash
   sudo ./scripts/user_audit.sh
   sudo ./scripts/log_parser.sh
   sudo ./scripts/fim_monitor.sh
   sudo ./scripts/cron_hunter.sh
   sudo ./scripts/system_hardening_audit.sh
   ```

4. **Review generated forensic reports:**
   All structured audit outputs are saved directly inside the `reports/` directory.

---

## Author & Contact

**Muzahidul Islam**  
*Network Security & SOC Operations Enthusiast | CCNA, Cisco Network Security & Linux Security Trained*  
- **GitHub:** [Md Muzahidul Islam](https://github.com/Muzahid-NetEng)
