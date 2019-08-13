#Get-ChildItem C:\Users\vvvv\Desktop\LogFiles -recurse *.txt |Remove-Item -Force
$LogFilePath = 'C:\Users\vvvv\Desktop\LogFiles'
$match='^TosRCTask.*'

Write-Host '查看VDS中已经输出的log'
Write-Host 'Please start VDS application and then hit any key'

Get-ChildItem $LogFilePath | Where-Object { $_.BaseName -match $match } | Sort-Object LastWriteTime -Desc| ForEach-Object -Process{
      
       Write-Host '-----order by LastWriteTime---------------------'$file
       Write-Host ""
       #write content
   　　Get-Content $_.FullName 
       #------
       Write-Host ""
}

$host.UI.RawUI.ReadKey()




