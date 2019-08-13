Start-Process 'C:\Program Files\dynaEdge\Vision DE Suite\TosRCTask.exe' -WorkingDirectory 'C:\Program Files\dynaEdge\Vision DE Suite'
Start-Sleep -Seconds 10
#1.纯cmdlet命令
Get-Process -Name TosRCTask | Stop-Process


