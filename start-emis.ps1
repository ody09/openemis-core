param([switch]$NoBrowser)

$ErrorActionPreference = 'Stop'
$localDir = Join-Path $PSScriptRoot '.local'
$url = 'http://127.0.0.1:8001'
$mutex = New-Object System.Threading.Mutex($false, 'Local\OpenEMISLocalStartup')
$locked = $false

function Test-LocalPort([int]$Port) {
    $client = New-Object System.Net.Sockets.TcpClient
    try {
        $pending = $client.ConnectAsync('127.0.0.1', $Port)
        return ($pending.Wait(500) -and $client.Connected)
    } catch { return $false }
    finally { $client.Dispose() }
}

try {
    try { $locked = $mutex.WaitOne(90000) }
    catch [System.Threading.AbandonedMutexException] { $locked = $true }
    if (-not $locked) { throw 'Another startup is still running. Try again shortly.' }

    foreach ($relative in @('php-8.3\php.exe', 'mysql-8.4.13-winx64\bin\mysqld.exe', 'mysql.ini', 'router.php')) {
        if (-not (Test-Path -LiteralPath (Join-Path $localDir $relative))) {
            throw "Required file is missing: $relative"
        }
    }

    if (-not (Test-LocalPort 3306)) {
        Write-Host 'Starting MySQL...'
        $database = Start-Process -FilePath "$localDir\mysql-8.4.13-winx64\bin\mysqld.exe" -ArgumentList ('--defaults-file="' + $localDir + '\mysql.ini"') -WorkingDirectory $PSScriptRoot -WindowStyle Hidden -PassThru
        $deadline = (Get-Date).AddSeconds(60)
        while (-not (Test-LocalPort 3306)) {
            if ($database.HasExited -or (Get-Date) -gt $deadline) {
                throw "MySQL did not start. See $localDir\mysql-error.log"
            }
            Start-Sleep -Milliseconds 500
        }
    }

    if (-not (Test-LocalPort 8001)) {
        Write-Host 'Starting OpenEMIS...'
        $server = Start-Process -FilePath "$localDir\php-8.3\php.exe" -ArgumentList @('-d', ('extension_dir="' + $localDir + '\php-8.3\ext"'), '-S', '127.0.0.1:8001', '-t', 'webroot', ('"' + $localDir + '\router.php"')) -WorkingDirectory "$PSScriptRoot\openemis-core" -WindowStyle Hidden -RedirectStandardOutput "$localDir\server-output.log" -RedirectStandardError "$localDir\server-error.log" -PassThru
    }

    $deadline = (Get-Date).AddSeconds(60)
    $ready = $false
    do {
        try {
            $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 10
            $ready = $response.StatusCode -eq 200 -and $response.Content -match 'OpenEMIS' -and $response.Content -notmatch 'Fatal error|Missing Database Connection'
        } catch { $ready = $false }
        if ($ready) { break }
        if ($server -and $server.HasExited) { break }
        Start-Sleep -Milliseconds 500
    } while ((Get-Date) -lt $deadline)
    if (-not $ready) { throw "OpenEMIS did not respond correctly. See $localDir\server-error.log (port 8001)." }

    Write-Host "OpenEMIS is ready: $url"
    if (-not $NoBrowser) { Start-Process $url }
} catch {
    Write-Host "Startup failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
} finally {
    if ($locked) { $mutex.ReleaseMutex() }
    $mutex.Dispose()
}
