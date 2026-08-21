@echo off
setlocal EnableExtensions EnableDelayedExpansion
title BEAST SUPPORT TOOLKIT
color 0B
net session >nul 2>&1
if %errorlevel% neq 0 (
 powershell.exe -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
 exit /b
)
:MENU
cls
echo ============================================================
echo                 BEAST SUPPORT TOOLKIT
echo ============================================================
echo   Running as Administrator
echo.
echo  [1] Windows Repair
 echo [2] Network Support
 echo [3] Hardware Information
 echo [4] Disk and Storage
 echo [5] BitLocker
 echo [6] Windows Administration
 echo [7] Event and Troubleshooting
 echo [8] Windows Admin Tools
 echo [9] Security
 echo [10] Reboot / Shutdown
 echo [0] Exit
 echo.
set /p "m=Select: "
if "%m%"=="1" goto WINREPAIR
if "%m%"=="2" goto NETWORK
if "%m%"=="3" goto HARDWARE
if "%m%"=="4" goto DISK
if "%m%"=="5" goto BITLOCKER
if "%m%"=="6" goto ADMIN
if "%m%"=="7" goto EVENTS
if "%m%"=="8" goto TOOLS
if "%m%"=="9" goto SECURITY
if "%m%"=="10" goto POWER
if "%m%"=="0" exit /b
goto MENU
:WINREPAIR
cls
echo ================= WINDOWS REPAIR =================
echo [1] DISM CheckHealth
echo [2] DISM ScanHealth
echo [3] DISM RestoreHealth
echo [4] SFC Scannow
echo [5] CHKDSK C: /scan
echo [6] Run all common repairs
echo [0] Back
set /p "x=Select: "
if "%x%"=="1" DISM /Online /Cleanup-Image /CheckHealth
if "%x%"=="2" DISM /Online /Cleanup-Image /ScanHealth
if "%x%"=="3" DISM /Online /Cleanup-Image /RestoreHealth
if "%x%"=="4" sfc /scannow
if "%x%"=="5" chkdsk C: /scan
if "%x%"=="6" (DISM /Online /Cleanup-Image /RestoreHealth & sfc /scannow & chkdsk C: /scan)
if "%x%"=="0" goto MENU
pause
goto WINREPAIR
:NETWORK
cls
echo ================= NETWORK SUPPORT =================
echo [1] Full IP configuration
echo [2] Flush DNS
echo [3] Renew DHCP
echo [4] Reset Winsock
echo [5] Reset TCP/IP
echo [6] Clear ARP cache
echo [7] Ping default gateway
echo [8] Internet test
echo [9] DNS test
echo [10] Tracert
echo [11] Route table
echo [12] Active connections
echo [13] Network adapters
echo [14] Generate Windows WLAN report
echo [0] Back
set /p "x=Select: "
if "%x%"=="1" ipconfig /all
if "%x%"=="2" ipconfig /flushdns
if "%x%"=="3" (ipconfig /release & ipconfig /renew)
if "%x%"=="4" netsh winsock reset
if "%x%"=="5" netsh int ip reset
if "%x%"=="6" arp -d *
if "%x%"=="7" powershell -NoProfile -Command "$g=(Get-NetIPConfiguration | ? {$_.IPv4DefaultGateway}).IPv4DefaultGateway.NextHop; if($g){Test-Connection $g -Count 4}else{Write-Host 'No default gateway found.'}"
if "%x%"=="8" powershell -NoProfile -Command "Test-Connection 1.1.1.1 -Count 4"
if "%x%"=="9" nslookup example.com
if "%x%"=="10" tracert 1.1.1.1
if "%x%"=="11" route print
if "%x%"=="12" netstat -ano
if "%x%"=="13" powershell -NoProfile -Command "Get-NetAdapter | Format-Table -AutoSize Name,Status,LinkSpeed,MacAddress"
if "%x%"=="14" netsh wlan show wlanreport
if "%x%"=="0" goto MENU
pause
goto NETWORK
:HARDWARE
cls
echo ================= HARDWARE =================
echo [1] PC / BIOS / OS information
echo [2] CPU
echo [3] RAM
echo [4] Motherboard
echo [5] GPU
echo [6] Disks
echo [7] Network adapters
echo [8] Battery report
echo [9] PnP devices with problems
echo [0] Back
set /p "x=Select: "
if "%x%"=="1" powershell -NoProfile -Command "Get-CimInstance Win32_ComputerSystem | fl Manufacturer,Model,SystemType,TotalPhysicalMemory; Get-CimInstance Win32_BIOS | fl Manufacturer,SMBIOSBIOSVersion,SerialNumber,ReleaseDate; Get-CimInstance Win32_OperatingSystem | fl Caption,Version,BuildNumber,OSArchitecture,LastBootUpTime"
if "%x%"=="2" powershell -NoProfile -Command "Get-CimInstance Win32_Processor | ft Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed -AutoSize"
if "%x%"=="3" powershell -NoProfile -Command "Get-CimInstance Win32_PhysicalMemory | ft Manufacturer,PartNumber,@{N='GB';E={[math]::Round($_.Capacity/1GB,2)}},Speed -AutoSize"
if "%x%"=="4" powershell -NoProfile -Command "Get-CimInstance Win32_BaseBoard | ft Manufacturer,Product,SerialNumber -AutoSize"
if "%x%"=="5" powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | ft Name,DriverVersion,AdapterRAM -AutoSize"
if "%x%"=="6" powershell -NoProfile -Command "Get-PhysicalDisk | ft FriendlyName,MediaType,HealthStatus,OperationalStatus,@{N='GB';E={[math]::Round($_.Size/1GB,2)}} -AutoSize"
if "%x%"=="7" powershell -NoProfile -Command "Get-NetAdapter | ft Name,Status,LinkSpeed,MacAddress -AutoSize"
if "%x%"=="8" powercfg /batteryreport /output "%USERPROFILE%\Desktop\battery-report.html"
if "%x%"=="9" powershell -NoProfile -Command "Get-PnpDevice | ? Status -ne 'OK' | ft Status,Class,FriendlyName,InstanceId -AutoSize"
if "%x%"=="0" goto MENU
pause
goto HARDWARE
:DISK
cls
echo ================= DISK / STORAGE =================
echo [1] Physical disk health
echo [2] Volumes
echo [3] CHKDSK scan
echo [4] DiskPart
echo [5] Free space
echo [6] Temp cleanup
echo [0] Back
set /p "x=Select: "
if "%x%"=="1" powershell -NoProfile -Command "Get-PhysicalDisk | ft FriendlyName,MediaType,HealthStatus,OperationalStatus,@{N='GB';E={[math]::Round($_.Size/1GB,2)}} -AutoSize"
if "%x%"=="2" powershell -NoProfile -Command "Get-Volume | ft DriveLetter,FileSystem,HealthStatus,@{N='FreeGB';E={[math]::Round($_.SizeRemaining/1GB,2)}},@{N='SizeGB';E={[math]::Round($_.Size/1GB,2)}} -AutoSize"
if "%x%"=="3" chkdsk C: /scan
if "%x%"=="4" diskpart
if "%x%"=="5" powershell -NoProfile -Command "Get-PSDrive -PSProvider FileSystem | ft Name,@{N='FreeGB';E={[math]::Round($_.Free/1GB,2)}},@{N='UsedGB';E={[math]::Round($_.Used/1GB,2)}} -AutoSize"
if "%x%"=="6" powershell -NoProfile -Command "$p=@($env:TEMP,'C:\Windows\Temp'); foreach($d in $p){Get-ChildItem $d -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue}"
if "%x%"=="0" goto MENU
pause
goto DISK
:BITLOCKER
cls
echo ================= BITLOCKER =================
echo [1] Status
echo [2] Protector types / IDs
echo [3] Suspend protectors for maintenance
echo [4] Re-enable protectors
echo [5] START FULL DECRYPTION - DANGEROUS
echo [0] Back
set /p "x=Select: "
if "%x%"=="1" manage-bde -status
if "%x%"=="2" manage-bde -protectors -get C:
if "%x%"=="3" manage-bde -protectors -disable C:
if "%x%"=="4" manage-bde -protectors -enable C:
if "%x%"=="5" (
 echo.
 echo WARNING: This starts full BitLocker decryption of C:.
 set /p "confirm=Type DECRYPT to continue: "
 if /I "!confirm!"=="DECRYPT" manage-bde -off C:
)
if "%x%"=="0" goto MENU
pause
goto BITLOCKER
:ADMIN
cls
echo ================= WINDOWS ADMIN =================
echo [1] Local users
echo [2] Local administrators
echo [3] Services
echo [4] Installed software
echo [5] Windows version
echo [6] Activation status
echo [7] Uptime
echo [8] Startup applications
echo [0] Back
set /p "x=Select: "
if "%x%"=="1" net user
if "%x%"=="2" net localgroup administrators
if "%x%"=="3" powershell -NoProfile -Command "Get-Service | sort Status,Name | ft Name,Status,StartType -AutoSize"
if "%x%"=="4" powershell -NoProfile -Command "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*,HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* -ErrorAction SilentlyContinue | ? DisplayName | select DisplayName,DisplayVersion,Publisher | sort DisplayName | ft -AutoSize"
if "%x%"=="5" winver
if "%x%"=="6" cscript //nologo %windir%\system32\slmgr.vbs /xpr
if "%x%"=="7" powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).LastBootUpTime"
if "%x%"=="8" powershell -NoProfile -Command "Get-CimInstance Win32_StartupCommand | ft Name,Location,Command,User -AutoSize"
if "%x%"=="0" goto MENU
pause
goto ADMIN
:EVENTS
cls
echo ================= EVENTS / TROUBLESHOOTING =================
echo [1] Recent System errors
echo [2] Recent Application errors
echo [3] Reliability Monitor
echo [4] System Information
echo [5] Generate support report
echo [0] Back
set /p "x=Select: "
if "%x%"=="1" powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='System';Level=1,2;StartTime=(Get-Date).AddDays(-3)} -MaxEvents 50 | select TimeCreated,Id,ProviderName,LevelDisplayName,Message | fl"
if "%x%"=="2" powershell -NoProfile -Command "Get-WinEvent -FilterHashtable @{LogName='Application';Level=2;StartTime=(Get-Date).AddDays(-3)} -MaxEvents 30 | select TimeCreated,Id,ProviderName,Message | fl"
if "%x%"=="3" perfmon /rel
if "%x%"=="4" msinfo32
if "%x%"=="5" (
 set "OUT=%USERPROFILE%\Desktop\BeastSupportReport.txt"
 (echo BEAST SUPPORT REPORT & echo ==================== & echo Date: %date% %time% & echo. & systeminfo & echo. & ipconfig /all & echo. & route print & echo. & netstat -ano & echo. & powershell -NoProfile -Command "Get-PhysicalDisk | ft FriendlyName,MediaType,HealthStatus,OperationalStatus,Size" & echo. & manage-bde -status) > "!OUT!"
 echo Report saved to !OUT!
)
if "%x%"=="0" goto MENU
pause
goto EVENTS
:TOOLS
cls
echo ================= WINDOWS ADMIN TOOLS =================
echo [1] Device Manager
echo [2] Disk Management
echo [3] Event Viewer
echo [4] Services
echo [5] Computer Management
echo [6] Network Connections
echo [7] Task Manager
echo [8] PowerShell
echo [9] Command Prompt
echo [0] Back
set /p "x=Select: "
if "%x%"=="1" devmgmt.msc
if "%x%"=="2" diskmgmt.msc
if "%x%"=="3" eventvwr.msc
if "%x%"=="4" services.msc
if "%x%"=="5" compmgmt.msc
if "%x%"=="6" ncpa.cpl
if "%x%"=="7" taskmgr.exe
if "%x%"=="8" start powershell.exe
if "%x%"=="9" start cmd.exe
if "%x%"=="0" goto MENU
pause
goto TOOLS
:SECURITY
cls
echo ================= SECURITY =================
echo [1] Microsoft Defender status
echo [2] Defender quick scan
echo [3] Firewall status
echo [4] Firewall profiles
echo [0] Back
set /p "x=Select: "
if "%x%"=="1" powershell -NoProfile -Command "Get-MpComputerStatus | select AMServiceEnabled,AntivirusEnabled,RealTimeProtectionEnabled,AntivirusSignatureVersion | fl"
if "%x%"=="2" powershell -NoProfile -Command "Start-MpScan -ScanType QuickScan"
if "%x%"=="3" netsh advfirewall show allprofiles state
if "%x%"=="4" powershell -NoProfile -Command "Get-NetFirewallProfile | ft Name,Enabled,DefaultInboundAction,DefaultOutboundAction -AutoSize"
if "%x%"=="0" goto MENU
pause
goto SECURITY
:POWER
cls
echo ================= POWER =================
echo [1] Restart in 30 seconds
echo [2] Shutdown in 30 seconds
echo [3] Cancel scheduled shutdown/restart
echo [0] Back
set /p "x=Select: "
if "%x%"=="1" shutdown /r /t 30
if "%x%"=="2" shutdown /s /t 30
if "%x%"=="3" shutdown /a
if "%x%"=="0" goto MENU
pause
goto POWER
