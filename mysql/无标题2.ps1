$start = Get-Date
$code1 = { Start-Sleep -Seconds 5; 'A' }
$code2 = { Start-Sleep -Seconds 6; 'B'}
$code3 = { Start-Sleep -Seconds 7; 'C'}
 
$result1,$result2,$result3= (& $code1),(& $code2),(& $code3)
 
$end =Get-Date
$timespan= $end - $start
$seconds = $timespan.TotalSeconds
 
Write-Host "总耗时 $seconds 秒."
Write-Host "三个脚本块总共延时 18 秒"