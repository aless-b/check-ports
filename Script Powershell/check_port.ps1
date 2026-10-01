<#
.SYNOPSIS
    Script en PowerShell para verificar si un puerto TCP está abierto o cerrado.
.EXAMPLE
    .\check_port.ps1 8080
    .\check_port.ps1 8080 127.0.0.1
    .\check_port.ps1 443 google.com
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, Position=0, HelpMessage="Número de puerto a revisar (1-65535)")]
    [ValidateRange(1, 65535)]
    [int]$Port,

    [Parameter(Mandatory=$false, Position=1, HelpMessage="Host o dirección IP (por defecto 127.0.0.1)")]
    [string]$HostName = "127.0.0.1",

    [Parameter(Mandatory=$false)]
    [int]$TimeoutMs = 2000
)

Write-Host "Verificando puerto $Port en $HostName..." -ForegroundColor Cyan

try {
    # Crear cliente TCP e intentar la conexión con timeout
    $client = New-Object System.Net.Sockets.TcpClient
    $asyncResult = $client.BeginConnect($HostName, $Port, $null, $null)
    $waitHandle = $asyncResult.AsyncWaitHandle

    # Esperar hasta el tiempo límite (2 segundos por defecto)
    if ($waitHandle.WaitOne($TimeoutMs, $false)) {
        if ($client.Connected) {
            $client.EndConnect($asyncResult) | Out-Null
            $client.Close()
            Write-Host "[+] El puerto $Port en $HostName está ABIERTO." -ForegroundColor Green
            exit 0
        }
    }
    
    $client.Close()
    Write-Host "[-] El puerto $Port en $HostName está CERRADO (o no responde)." -ForegroundColor Red
    exit 1
} catch {
    Write-Host "[-] El puerto $Port en $HostName está CERRADO (o no responde)." -ForegroundColor Red
    exit 1
}
