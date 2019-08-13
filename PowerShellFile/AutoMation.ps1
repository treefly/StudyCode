$LogFilePath = $env:USERPROFILE + '\Documents\Vision DE Suite\Settings\LogFiles'
$match='^AutoTestVDS.*'
try 
{
	Remove-Item $LogFilePath\*.log -ErrAction Ignore
}
catch 
{

}
Write-Host 'VDS_ShowLog for VDS(DEBUG-mod)'
Write-Host 'Please start VDS application and then hit any key'
$host.UI.RawUI.ReadKey()
$LatestLogFileName = (Get-ChildItem $LogFilePath | Where-Object { $_.BaseName -match $match } | Sort-Object LastWriteTime -Desc)[0].Name
$LogFileNameWithPath = Join-Path $LogFilePath $LatestLogFileName
Write-Host 'Opening -->' $LogFileNameWithPath
Write-Host ''
Write-Host ''
try 
{
	Get-Content $LogFileNameWithPath -wait -tail 0
    
}
catch 
{
	Write-Host 'No available log file'
}
