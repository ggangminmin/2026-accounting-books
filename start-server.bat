@echo off
echo Starting local server on http://localhost:8000...
echo.
echo Press Ctrl+C to stop the server
echo.

start chrome http://localhost:8000

python -m http.server 8000
