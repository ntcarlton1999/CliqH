# CliqH — one-command startup (Windows PowerShell)
$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot

Write-Host "=== CliqH Setup & Start ===" -ForegroundColor Cyan

# Python venv
if (-not (Test-Path "$Root\.venv\Scripts\python.exe")) {
    Write-Host "Creating Python virtual environment..."
    python -m venv "$Root\.venv"
}

Write-Host "Installing Python dependencies..."
& "$Root\.venv\Scripts\pip.exe" install -r "$Root\requirements.txt" -q
& "$Root\.venv\Scripts\pip.exe" install "bcrypt==4.0.1" -q

# Seed database
Write-Host "Seeding database..."
& "$Root\.venv\Scripts\python.exe" "$Root\scripts\seed_data.py" --seed

# Frontend deps
if (-not (Test-Path "$Root\src\frontend\node_modules")) {
    Write-Host "Installing frontend dependencies..."
    Push-Location "$Root\src\frontend"
    npm install
    Pop-Location
}

Write-Host ""
Write-Host "Starting CliqH..." -ForegroundColor Green
Write-Host "  API:      http://localhost:8000/docs"
Write-Host "  Web App:  http://localhost:5173"
Write-Host ""

# Start backend in background job
$backend = Start-Process -FilePath "$Root\.venv\Scripts\uvicorn.exe" `
    -ArgumentList "src.backend.main:app", "--reload", "--port", "8000" `
    -WorkingDirectory $Root -PassThru -WindowStyle Hidden

Start-Sleep -Seconds 3

# Start frontend (foreground)
Push-Location "$Root\src\frontend"
try {
    npm run dev
} finally {
    Pop-Location
    if ($backend -and -not $backend.HasExited) {
        Stop-Process -Id $backend.Id -Force -ErrorAction SilentlyContinue
    }
}
