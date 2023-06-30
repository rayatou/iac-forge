@REM %SystemRoot%\System32\Sysprep\Sysprep.exe /generalize /oobe /shutdown /unattend:"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\Unattend.xml"

@echo OFF
time /t

@echo ON
cd "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf"
dir
%SystemRoot%\System32\Sysprep\Sysprep.exe /generalize /oobe /shutdown /unattend:"Unattend.xml"

@echo OFF
time /t