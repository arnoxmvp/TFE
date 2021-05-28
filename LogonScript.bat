@echo off
set datetimef=20%date:~-2%/%date:~3,2%/%date:~0,2%-%time:~0,2%:%time:~3,2%:%time:~6,2%
set USERDOMAIN=contoso.com
for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do set NetworkIP=%%a
rem Network IP: %NetworkIP%

if exist \\share\grafana\logs\%USERDOMAIN%\20%date:~-2%%date:~3,2%-%USERDOMAIN%-ADLogon.txt goto e
if not exist \\share\grafana\logs\%USERDOMAIN%\20%date:~-2%%date:~3,2%-%USERDOMAIN%-ADLogon.txt goto ne

:e
echo %datetimef%	%USERDOMAIN%	%COMPUTERNAME%	%USERNAME%	%NetworkIP% >> \\share\grafana\logs\%USERDOMAIN%\20%date:~-2%%date:~3,2%-%USERDOMAIN%-ADLogon.txt
goto eof

:ne
echo DateTime		DomainName	ComputerName	UserName	IPAddress >> \\share\grafana\logs\%USERDOMAIN%\20%date:~-2%%date:~3,2%-%USERDOMAIN%-ADLogon.txt
echo %datetimef%	%USERDOMAIN%	%COMPUTERNAME%	%USERNAME%	%NetworkIP% >> \\share\grafana\logs\%USERDOMAIN%\20%date:~-2%%date:~3,2%-%USERDOMAIN%-ADLogon.txt
goto eof

:eof
