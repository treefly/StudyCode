$LogFilePath = $env:USERPROFILE + '\Documents\dynaEdge\Voice Command Service\Log'
try {
	Remove-Item $LogFilePath\*.log -ErrAction Ignore
}
catch {}
Write-Host 'VCS_ShowLog for VCS(Final-mod)'
Write-Host 'Please start VCS application and then hit any key'
$host.UI.RawUI.ReadKey()
$LatestLogFileName = (Get-ChildItem $LogFilePath | Sort-Object LastWriteTime -Desc)[0].Name
$LogFileNameWithPath = Join-Path $LogFilePath $LatestLogFileName
Write-Host 'Opening -->' $LogFileNameWithPath
Write-Host ''
Write-Host ''
try {
	Get-Content $LogFileNameWithPath -wait -tail 0
}
catch {
	Write-Host 'No available log file'
}
