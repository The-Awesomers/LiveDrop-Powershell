@ECHO OFF
REM.-- Prepare the Command Processor
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION

:menuLOOP
echo.
echo.= Menu =================================================
echo.
for /f "tokens=1,2,* delims=_ " %%A in ('"findstr /b /c:":menu_" "%~f0""') do echo.  %%B  %%C
set choice=
echo.&set /p choice=Make a choice or hit ENTER to quit: ||GOTO:EOF
echo.&call:menu_%choice%
GOTO:menuLOOP

::-----------------------------------------------------------::
:: menu functions follow below here                          ::
::-----------------------------------------------------------::




REM Will find the current users download directory, even if they move directory, this script will still find as it pulls from the registry.
:menu_1  DownloadSnoop             
cls
FOR /F "tokens=3" %%G IN ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "{374DE290-123F-4565-9164-39C4925E467B}"') DO (set docsdir=%%G)
dir %docsdir%
GOTO:EOF

REM Gets Current Date and Time, Syncs with Atomic Clock, and configures date/time format for the region of the world your in.
:menu_2   WhereWhenAmI?     
cls
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
set /P b=Retrieve date independently of the region day/month order,[Y/N]?
if /I "%b%" EQU "Y" goto :Yes
if /I "%b%" EQU "N" goto :No

:Yes
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2% %ldt:~8,2%:%ldt:~10,2%:%ldt:~12,6%
echo Local date is [%ldt%]

:No
echo %date% %time%
pause
GOTO:EOF

:menu_3   UserAccountInfo
cls
wmic useraccount get name,sid
set /p a=Would youlike to export to a CSV file[Y/N]?
if /I "%a%" EQU "Y" goto :CSV
if /I "%a%" EQU "N" goto :NCSV

:CSV
set /p InputSaveName3=""
%InputSaveName3%
wmic useraccount get name,sid /format:csv > %InputSaveName3%.csv 

GOTO:EOF

:NCSV 
GOTO:EOF

:menu_4 InfoDigger
cls 

mkdir C:\InfoDigger\ 
mkdir C:\InfoDigger\Serials\

REM Generates detailed technical information about the pc.
Get-Computerinfo | Tee-Object -FilePath "C:\InfoDigger\ComputerInfo.txt" -Append | Out-Null
Get-WmiObject -Class Win32_ComputerSystem | Tee-Object -FilePath "C:\InfoDigger\ComputerInfo.txt" -Append | Out-Null
Get-WmiObject -Class Win32_OperatingSystem -ComputerName . | Select-Object -Property BuildNumber,BuildType,OSType,ServicePackMajorVersion,ServicePackMinorVersion | Tee-Object -FilePath "C:\InfoDigger\ComputerInfo.txt" -Append | Out-Null
Get-WmiObject -Class Win32_OperatingSystem -ComputerName . | Select-Object -Property NumberOfLicensedUsers,NumberOfUsers,RegisteredUser | Tee-Object -FilePath "C:\InfoDigger\ComputerInfo.txt" -Append | Out-Null
Get-WmiObject -Class Win32_OperatingSystem -Namespace root/cimv2 -ComputerName . | Get-Member -MemberType Property | Tee-Object -FilePath "C:\InfoDigger\ComputerInfo.txt" -Append | Out-Null

REM Bios Info 
Get-WmiObject -List *bios* | Tee-Object -FilePath "C:\InfoDigger\Bios.txt" -Append | Out-Null
Get-WmiObject Win32_BIOS | Tee-Object -FilePath "C:\InfoDigger\Bios.txt" -Append | Out-Null

REM CPU Info
Get-WmiObject -List *processor* | Tee-Object -FilePath "C:\InfoDigger\Cpu.txt" -Append | Out-Null
get-wmiobject Win32_Processor | Tee-Object -FilePath "C:\InfoDigger\Cpu.txt" -Append | Out-Null

REM OS Info
Get-WmiObject -Class Win32_OperatingSystem | Tee-Object -FilePath "C:\InfoDigger\OS.txt" -Append | Out-Null


REM Disk/Filesystem Information
Get-PhysicalDiskStorageNodeView | Tee-Object -FilePath "C:\InfoDigger\PhysicalDiskNODEVIEW.txt" -Append | Out-Null
Get-WmiObject Win32_MemoryDevice | Tee-Object -FilePath "C:\InfoDigger\PhysicalDiskNODEVIEW.txt" -Append | Out-Null


REM Shows What Windows updates where installed and When
wmic qfe | Tee-Object -FilePath "C:\InfoDigger\Installed updates.txt" -Append | Out-Null

REM High level disk info
Get-fileshare | Tee-Object -FilePath "C:\InfoDigger\DiskDiginfo.txt" -Append | Out-Null
Get-Disk | Tee-Object -FilePath "C:\InfoDigger\DiskDiginfo.txt" -Append | Out-Null
Get-Partition | Tee-Object -FilePath "C:\InfoDigger\DiskDiginfo.txt" -Append | Out-Null
Get-PhysicalDisk | Tee-Object -FilePath "C:\InfoDigger\DiskDiginfo.txt" -Append | Out-Null
Get-Volume | Tee-Object -FilePath "C:\InfoDigger\DiskDiginfo.txt" -Append | Out-Null

REM NIC Info
Get-Netadapter | Tee-Object -FilePath "C:\InfoDigger\NICinfo.txt" -Append | Out-Null
Get-NetAdapterAdvancedProperty | Tee-Object -FilePath "C:\InfoDigger\NICinfo.txt" -Append | Out-Null
Get-NetAdapterBinding | Tee-Object -FilePath "C:\InfoDigger\NICinfo.txt" -Append | Out-Null
Get-NetAdapterChecksumOffload | Tee-Object -FilePath "C:\InfoDigger\NICinfo.txt" -Append | Out-Null
Get-NetAdapterHardwareInfo | Tee-Object -FilePath "C:\InfoDigger\NICinfo.txt" -Append | Out-Null
Get-NetAdapterPowerManagement | Tee-Object -FilePath "C:\InfoDigger\NICinfo.txt" -Append | Out-Null
Get-NetAdapterStatistics | Tee-Object -FilePath "C:\InfoDigger\NICinfo.txt" -Append | Out-Null
Get-wmiobject win32_networkadapter | Tee-Object -FilePath "C:\InfoDigger\NICinfo.txt" -Append | Out-Null



REM USB Info
gwmi Win32_USBControllerDevice |%{[wmi]($_.Dependent)} | Sort Manufacturer,Description,DeviceID | Ft -GroupBy Manufacturer Description,Service,DeviceID | Tee-Object "C:\InfoDigger\Usb.txt" -Append | Out-Null


REM Video Controller
Get-WmiObject win32_videocontroller | Tee-Object -FilePath "C:\InfoDigger\VideoController.txt" -Append | Out-Null
Get-WmiObject win32_videocontroller | select caption, CurrentHorizontalResolution, CurrentVerticalResolution | Tee-Object -FilePath "C:\InfoDigger\VideoController.txt" -Append | Out-Null
Get-WmiObject win32_desktopmonitor | Tee-Object -FilePath "C:\InfoDigger\VideoController.txt" -Append | Out-Null
Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBasicDisplayParams | Tee-Object -FilePath "C:\InfoDigger\VideoController.txt" -Append | Out-Null

REM Log-On Info
Get-WmiObject -Class Win32_LogonSession -ComputerName . | Tee-Object -FilePath "C:\InfoDigger\LogOn.txt" -Append| Out-Null
Get-WmiObject -Class Win32_ComputerSystem -Property UserName -ComputerName . | Out-Null

REM Service Status
Get-WmiObject -Class Win32_Service -ComputerName . | Format-Table -Property Status,Name,DisplayName -AutoSize -Wrap | Tee-Object -FilePath "C:\InfoDigger\ServiceStatus.txt" -Append | Out-Null

REM Serials
gwmi win32_bios | fl SerialNumber | Tee-Object -FilePath "C:\InfoDigger\Serials\Bios.txt" -Append| Out-Null
 

REM Installed Programs
Get-WmiObject -Class Win32_Product | Select-Object -Property Name | Sort-Object Name | Tee-Object -FilePath "C:\InfoDigger\Programs.txt" -Append | Out-Null



echo "Go to C:\InfoDigger for results" | Out-Null


GOTO:EOF


Read-Host -Prompt “Press Enter to exit”



:menu_5 Windows Updater AutoAll
cls
REM Windows Update Tool AutoAllAutoReboot

Get-WUInstall -Acceptall -Autoreboot -Verbose
GOTO:EOF



:menu_6 Windows Update Manual
cls 
Get-WUInstall
GOTO:EOF

