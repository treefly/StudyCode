param( $a, $b )
#region 关键代码：强迫以管理员权限运行
$currentWi = [Security.Principal.WindowsIdentity]::GetCurrent()
$currentWp = [Security.Principal.WindowsPrincipal]$currentWi
 
if( -not $currentWp.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  $boundPara = ($MyInvocation.BoundParameters.Keys | foreach{
     '-{0} {1}' -f  $_ ,$MyInvocation.BoundParameters[$_]} ) -join ' '
  $currentFile =$MyInvocation.MyCommand.Definition
  Start-Process "$psHome\powershell.exe"   -ArgumentList "$currentFile "   -verb runas
  return
}
#set command path
$sysPath= $env:SystemRoot +"\system32"
cd $sysPath
# resync time
w32tm /resync