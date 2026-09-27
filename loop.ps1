param (
    [int]$Cycles = 5,
    [int]$DelayMinutes = 45,
    [switch]$Real
)

# 1. Concurrency Check (Lock Mechanism)
$LockFile = "./.loop.lock"
if (Test-Path $LockFile) {
    Write-Error "Error: Another instance of Phil is already running in this directory. Delete '.loop.lock' if this is a mistake."
    exit 1
}
New-Item -Path $LockFile -ItemType File | Out-Null

try {
    Write-Host "Starting Phil Native Windows Orchestration Loop..." -ForegroundColor Green
    Write-Host "Total Cycles: $Cycles | Delay: $DelayMinutes minutes | Real Money: $($Real.IsPresent)"

    # Build the flags for Claude Code execution
    $RealFlag = if ($Real) { "--real" } else { "" }

    for ($i = 1; $i -le $Cycles; $i++) {
        Write-Host "--- Cycle $i of $Cycles ---" -ForegroundColor Cyan
        Write-Host "Executing Claude Code at $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Gray

        # 2. Security / Safeguard Integrity Check Placeholder
        if (Test-Path "./config/protected.json") {
            # Intentionally left for engine synchronization if required by the repo
        }

        # 3. Native Windows Execution
        # Invoking your Windows-installed Claude tool
        if ($Real) {
            claude run --real
        } else {
            claude run
        }

        # 4. Handle standard delay interval between rounds
        if ($i -lt $Cycles) {
            Write-Host "Cycle $i complete. Sleeping for $DelayMinutes minutes..." -ForegroundColor Yellow
            Start-Sleep -Seconds ($DelayMinutes * 60)
        }
    }
}
finally {
    # 5. Cleanup the lock file gracefully on completion or break (Ctrl+C)
    if (Test-Path $LockFile) {
        Remove-Item $LockFile -Force
    }
    Write-Host "Orchestration loop ended safely. Lock file removed." -ForegroundColor Green
}
