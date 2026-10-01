#!/bin/bash

# ==============================================================================
# Script para verificar si un puerto TCP está abierto o cerrado en un host.
# Uso: ./check_port.sh <puerto> [host]
# Ejemplo: ./check_port.sh 8080
# Ejemplo: ./check_port.sh 443 google.com
# ==============================================================================

# 1. Validar que se haya pasado al menos un argumento (el puerto)
if [ -z "$1" ]; then
    echo "Error: Debe proporcionar un número de puerto."
    echo "Uso: $0 <puerto> [host]"
    exit 1
fi

PORT=$1
HOST=${2:-127.0.0.1} # Por defecto revisa 127.0.0.1 (localhost)

# 2. Validar que el puerto sea un número entero válido (1-65535)
if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
    echo "Error: '$PORT' no es un número de puerto válido (debe ser entre 1 y 65535)."
    exit 1
fi

echo "Verificando el puerto $PORT en $HOST..."

# 3. Intentar conexión al puerto (usando /dev/tcp o netcat)
if command -v timeout >/dev/null 2>&1; then
    timeout 2 bash -c "</dev/tcp/$HOST/$PORT" 2>/dev/null
    STATUS=$?
else
    (echo > "/dev/tcp/$HOST/$PORT") 2>/dev/null
    STATUS=$?
fi

# Alternativa con netcat (nc) si /dev/tcp no está disponible
if [ $STATUS -ne 0 ] && command -v nc >/dev/null 2>&1; then
    nc -z -w 2 "$HOST" "$PORT" 2>/dev/null
    STATUS=$?
fi

# 4. Mostrar resultado
if [ $STATUS -eq 0 ]; then
    echo "[+] El puerto $PORT en $HOST está ABIERTO."
    exit 0
else
    echo "[-] El puerto $PORT en $HOST está CERRADO (o no responde)."
    exit 1
fi
