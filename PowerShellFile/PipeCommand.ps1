Set-Location -Path C:\Users\vvvv\Desktop\Code\GitHub\StudyCode\StudyCode\PowerShellFile
#输出数据到文件中
get-process | Export-Csv process.csv

#读取csv文件
Import-Csv pro.csv

#对比文件命令
help Compare-Object
#获取compare-object 例子
help Get-Alias -Examples Compare-Object
#获取别名
Get-Alias -Definition Compare-Object

#将数据输出到文件中--命令
dir > Directiorylist.txt
dir |Out-File directory1.txt
dir |Out-Default #输出到显示器中
dir |Out-Printer #输出到打印器

#输出结果到一个GridView 中，弹框
Get-Service |Out-GridView
#ConvertTo- 将数据转换成-某种数据类型csv/html/json/xml 这是常见的类型
Get-Service |ConvertTo-Html

<#
动词“ Export” 意味着 你把 数据 提取 出来，
 然后 转换 成 其他 格式， 
 最后 把 转换 后的 格式 以 某种 形式 保存， 如 文件。 
 而 动词“ ConvertTo” 仅仅是 处理 过程 的 一部分，
 它 仅 转换 不 保存。
#>

#可以先转换在保存数据
Get-Service |ConvertTo-Html|Out-File services.html

#常见影响界别，其实就是将命令做了一层限制
$ConfirmPreference