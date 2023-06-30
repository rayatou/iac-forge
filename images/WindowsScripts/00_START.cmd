chcp 65001

Start /WAIT /B a:\01_IPv6.cmd
Start /WAIT /B a:\02_vmtools.cmd
Start /WAIT /B a:\03_enable-rdp.cmd
Start /WAIT /B powershell  a:\04_winrm.ps1

timeout /T 100
