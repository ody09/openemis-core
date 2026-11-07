@echo off
cd /d "%~dp0openemis-core"
echo OpenEMIS: http://127.0.0.1:8001
echo Keep this window open while using OpenEMIS. Press Ctrl+C to stop.
"%~dp0.local\php-8.3\php.exe" -d extension_dir="%~dp0.local\php-8.3\ext" -S 127.0.0.1:8001 -t webroot "%~dp0.local\router.php"
pause
