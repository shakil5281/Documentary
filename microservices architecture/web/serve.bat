@echo off
cd /d "%~dp0.."
echo.
echo   Microservices Architecture Learning Viewer
echo   Open: http://localhost:8080/web/index.html
echo   Root must be the "microservices architecture" folder.
echo   Press Ctrl+C to stop.
echo.
start http://localhost:8080/web/index.html
python -m http.server 8080
if errorlevel 1 (
  echo Python not found. You can still open web\index.html - uses content-bundle.js offline.
  pause
)
