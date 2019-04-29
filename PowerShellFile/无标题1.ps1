# Help Get-Content 
# Get-Help Get-Content
Help Get-Content | More

Help *log*

help *event*

Help Get-EventLog

<#
  获取帮助文档值

    Get-EventLog [-LogName] <String> [[-InstanceId] <Int64[]>] [-After <DateTime>] [-AsBaseObject] [-
    Before <DateTime>] [-ComputerName <String[]>] [-EntryType {Error | Information | FailureAudit | S
    uccessAudit | Warning}] [-Index <Int32[]>] [-Message <String>] [-Newest <Int32>] [-Source <String
    []>] [-UserName <String[]>] [<CommonParameters>]
    
    Get-EventLog [-AsString] [-ComputerName <String[]>] [-List] [<CommonParameters>]

    （1）俩个构造函数
    （2）【】代表可选参数
#>

Get-EventLog

#Write-Host ： 将自定义输出内容写入主机。类似于.net的 write()或者writeline()功能
Write-Host "Hello,$args"
Write-Host "123124,sdgaseig"

# Windows PowerShell 命令窗口内显示进度栏
for($i = 1; $i -lt 101; $i++ )
{for($j=0;$j -lt 10000;$j++) {} write-progress "Search in Progress" "% Complete:" -perc $i;}

#.Write-Debug ：将调试消息写入控制台
 Write-Debug "Cannot open file." -Debug