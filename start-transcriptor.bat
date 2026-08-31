@echo off
chcp 65001 >nul
rem ============================================================
rem  Transcriptor - launcher (Windows x64, BASE LOCAL)
rem  Repo:    D:\Projects\Voice-Transcriptor
rem  Python:  bundled venv (.venv) with faster-whisper backend
rem  ffmpeg:  winget Gyan.FFmpeg build added to PATH
rem  Models:  local already downloaded (small/medium/large-v3 + GigaAM)
rem  Mode:    base out-of-box, no proxy/bridge
rem ============================================================
setlocal
set "REPO=D:\Projects\Voice-Transcriptor"
set "PYTHON=%REPO%\.venv\Scripts\python.exe"
set "FFMPEG_BIN=%LOCALAPPDATA%\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-9.0.1-full_build\bin"
set "NODE_ENV=development"
rem Clear proxy vars from previous free-model experiments
set "TRANSCRIPTOR_OPENROUTER_BASE_URL="
set "TRANSCRIPTOR_REMOTE_CATALOG="
set "OPENROUTER_BASE_URL="
set "PATH=%FFMPEG_BIN%;%PATH%"

cd /d "%REPO%"

if not exist "%PYTHON%" (
  echo [ERROR] venv python not found: %PYTHON%
  echo         Run: python -m venv .venv && pip install -r requirements.txt
  pause
  exit /b 1
)

if not exist "%FFMPEG_BIN%\ffmpeg.exe" (
  echo [WARN] ffmpeg not found at %FFMPEG_BIN%
  echo        Install: winget install Gyan.FFmpeg
)

if not exist "frontend\dist\index.html" (
  echo [prep] building frontend...
  call npm --prefix frontend run build
  if errorlevel 1 (
    echo [ERROR] frontend build failed
    pause
    exit /b 1
  )
)

echo [run] starting Transcriptor (local models, base config)...
start "Transcriptor" /D "%REPO%" "%REPO%\desktop\node_modules\.bin\electron.cmd" desktop
exit /b 0
