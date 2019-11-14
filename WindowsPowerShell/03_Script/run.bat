@echo off
echo %date% %time% 

powershell -NoProfile -ExecutionPolicy Unrestricted .\RebuildingDirectory.ps1

echo %date% %time% 
pause > nul
exit
