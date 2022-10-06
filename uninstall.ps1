Get-Service PyPiserver

Get-Service PyPiserver | Where {$_.status –eq 'Running'} |  Stop-Service
Get-Service PyPiserver
sc.exe delete PypiServer