# TCP Port Status Checker Utilities

A set of lightweight command-line utility scripts designed to check whether a specific TCP port on a given host is open or closed/unreachable. This repository provides cross-platform implementations for both **Linux/Unix (Bash)** and **Windows (PowerShell)** environments.

---

## 📁 Repository Structure

```text
Practica_Puertos/
├── README.md
├── Script Powershell/
│   └── check_port.ps1    # PowerShell script for Windows environments
└── Script Shell/
    └── check_port.sh     # Bash shell script for Linux/macOS/Docker
```

---

## ✨ Features

- **Input Validation:** Automatically validates that the specified port is an integer within the valid range (`1`–`65535`).
- **Flexible Host Selection:** Allows passing a custom target host or IP address (defaults to `127.0.0.1` if omitted).
- **Non-blocking Timeout:** Enforces a connection timeout (2 seconds) to prevent scripts from hanging indefinitely.
- **Cross-Platform:** Native implementations for both Bash (utilizing `/dev/tcp` and `netcat`) and PowerShell (utilizing `System.Net.Sockets.TcpClient`).
- **Exit Code Integration:** Returns standard process exit codes (`0` for OPEN, `1` for CLOSED/Failed), making it suitable for automation and CI/CD pipelines.

---

## 🚀 Usage

### 1. Bash Script (`check_port.sh`)

#### Syntax:
```bash
./check_port.sh <port> [host]
```

#### Prerequisites:
Make sure the script has execution permissions:
```bash
chmod +x "Script Shell/check_port.sh"
```

#### Examples:
```bash
# Check port 8080 on localhost (127.0.0.1)
./check_port.sh 8080

# Check port 443 on an external domain
./check_port.sh 443 google.com
```

#### Running inside a Docker Container:
```bash
# Execute from host against a running container
docker exec -it <container_name> /lab/scripts/check_port.sh 8080

# Or run via stdin without copying files into the container
docker exec -i <container_name> bash -s 8080 google.com < "Script Shell/check_port.sh"
```

---

### 2. PowerShell Script (`check_port.ps1`)

#### Syntax:
```powershell
.\check_port.ps1 [-Port] <int> [[-HostName] <string>]
```

#### Prerequisites:
If script execution is disabled on your system, allow it for the current process:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

#### Examples:
```powershell
# Check port 8080 on localhost
.\check_port.ps1 8080

# Check port 443 on google.com
.\check_port.ps1 443 google.com

# Using named parameters
.\check_port.ps1 -Port 8080 -HostName "127.0.0.1"
```

---

## 📊 Output & Exit Codes

| Status | Output Message Example | Exit Code |
| :--- | :--- | :---: |
| **Open** | `[+] El puerto 8080 en 127.0.0.1 está ABIERTO.` | `0` |
| **Closed / Unreachable** | `[-] El puerto 8080 en 127.0.0.1 está CERRADO (o no responde).` | `1` |
| **Invalid Input** | `Error: '99999' no es un número de puerto válido...` | `1` |

---

## 🛡️ License & Use Case
Designed for Cybersecurity educational labs, port scanning verification, and containerized network diagnostics.
