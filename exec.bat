@echo off

set datecheck=20%date:~-2%%date:~3,2%
set mosquitto=C:/XXX_Grafana/Mosquitto/mosquitto_pub.exe
set server=dc-1.contoso.com
set domain=contoso.com
set broker=mosquitto.contoso.com
set xml_location=C:/XXX_Grafana/ad_hc_%domain%.xml
set tags_location=C:/XXX_Grafana/tags.txt
set smb_report=C:/XXX_Grafana/ad_scanner_smb_%domain%.txt
set share_report=C:/XXX_Grafana/ad_scanner_share_%domain%.txt
set logs_file=//share/grafana/logs/%domain%/%datecheck%-%domain%-ADLogon.csv
set loginlist=C:/XXX_Grafana/ListeLogin.txt
set cafile=C:/XXX_Grafana/Mosquitto/certs/ca.crt
set certfile=C:/XXX_Grafana/Mosquitto/certs/client.crt
set keyfile=C:/XXX_Grafana/Mosquitto/certs/client.key


Powershell.exe -executionpolicy remotesigned -File  ADscript.ps1 -server %server% -domain %domain% -broker %broker% -cafile %cafile% -certfile %certfile% -keyfile %keyfile%
C:/XXX_Grafana/PingCastle/PingCastle.exe --healthcheck --server %domain%
C:/XXX_Grafana/PingCastle/PingCastle.exe --scanner smb --server %domain%
C:/XXX_Grafana/PingCastle/PingCastle.exe --scanner share --server %domain%


python XMLparser.py %mosquitto% %cafile% %certfile% %keyfile% %xml_location% %tags_location% %broker% %domain%
python SMBParser.py %mosquitto% %cafile% %certfile% %keyfile% %smb_report% %broker% %domain% 
python shareCounter.py %mosquitto% %cafile% %certfile% %keyfile% %share_report% %broker% %domain% 
python userCounter.py %mosquitto% %cafile% %certfile% %keyfile% %logs_file% %loginlist% %broker% %domain%
