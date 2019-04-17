# 先来看看常用的文件管理命令。

# Set-Location命令用于切换工作目录，它的别名是cd。
# Get-Location命令用于获取当前工作目录，它的别名是pwd。
# Get-ChildItem命令用于获取当前目录下的所有文件。
# Get-Item命令用于获取给定文件的信息。

#文件移动、删除、复制、粘贴、重命名等命令，输入Get-Command -Noun item
Get-Command -Noun item

#过滤文件
#用Get-ChildItem显示当前当前文件的时候，会显示所有文件。有时候我们可能仅仅需要搜索或者过滤部分文件。
cd 'C:\Users\vvvv\Desktop\201904170417\DERCS Front-end(Release)'

#比较简单的需求，可以使用?*通配符来搞定，问号用于匹配任意单个字符，星号用于匹配任意多个字符
Get-childitem *.exe

#Get-ChildItem没有正则表达式查询的命令行，不过我们可以使用Where-Object命令来自定义查询.
# Where-Object和正则表达式，其中Where-Object里面的$_是形式变量，代表每次迭代的文件.
Get-ChildItem|Where-Object {$_ -match '\w*.md$'}

#多个条件
Get-ChildItem|Where-Object {$_ -match '\w*.md$' -and $_.Length/1kb -gt 5}

#可以添加递归子文件夹，如果需要的话，还可以添加深度
Get-ChildItem -Recurse *.exe

#修改hosts
#访问谷歌的一种方式就是更改hosts文件。这里就用Powershell做一个修改hosts的功能。

# 首先先来介绍一个命令Invoke-WebRequest，利用它我们可以获取网页内容、下载文件甚至是填写表单。
#这个命令的别名是iwr、curl和wget。我们就使用它来下载网上的hosts文件。

#进程管理

#查看和进程相关的命令
Get-Command -Noun process
#查询正则运行的进程
Get-Process

#查询进程，对结果进行排序，筛选前5个进程
Get-Process chrome|Sort-Object cpu -Descending|Select-Object -First 5
Get-Process chrome|Sort-Object cpu -Descending|Select-Object -First 15

#管理进程
notepad;notepad;notepad;#打开进程
$notepads=Get-Process -Name notepad #查询获取进程
$notepads.Count #统计进程的数量
$notepads.Kill() # 杀掉进程

#轮询进程 --关掉
$process_name = "taskmgr"
while ($false) #不运行，否则电脑有问题
{
    $processes = Get-Process
    if ($processes.Name -contains $process_name) 
    {
        Get-Process $process_name|Stop-Process
    }
    else {
        Start-Sleep -Milliseconds 500
    }

}

#码中的taskmgr换成英雄联盟的进程名字，我们就可以做一个简单的“熊孩子防火墙”


#读取注册表
#注册表的缩写 如HKEY_CURRENT_USER的简写就是HKCU，HKEY_LOCAL_MACHINE的简写就是HKLM
#切换到注册表
Set-Location 'HKCU:\Control Panel\Desktop\MuiCached'
#切换到注册表后获取值。
Get-Item .
#获取属性值
Get-ItemProperty .  MachinePreferredUILanguages

#也可以不切换目录，直接根据路径参数获取
Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop\MuiCached' -Name MachinePreferredUILanguages


#编辑注册表
$path = "HKCU:\Control Panel\Desktop"
#创建新的信息
New-Item –Path $path –Name HelloKey
#修改信息
Set-ItemProperty -path $path\hellokey -name Fake -Value fuck
#删除信息
Remove-ItemProperty -path $path\hellokey -name Fake
#删除整个注册项
Remove-Item -path $path\hellokey -Recurse

#获取当前NET版本
$path = 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'
$not_found_msg = ".net framework 4.5 or later not installed on your system"




#操作Excel
#打开和关闭
#创建Excel 对象，默认隐藏
$excel = New-Object -ComObject Excel.Application
$excel.Visible=$true#显示

#打开工作簿
$workbook = $excel.Workbooks.Open("XXX.xlsx")

#创建工作簿
$workbook = $excel.Workbooks.Add()

#获取工作表（某个sheet）
$worksheet = $workbook.Worksheets.Item(1)

#数据操作完成后，保存数据
$workbook.SaveAs("D:\Desktop\hello.xlsx")


#操作Excel 数据信息
$worksheet = $workbook.Worksheets.Item(1)

#数据9*9 乘法表  excel 写入数据
for ($i = 1; $i -le 9; ++$i) 
{
    # 第一行
    $worksheet.Cells(1, $i + 1) = $i
    # 第一列
    $worksheet.Cells($i + 1, 1) = $i
    # 它们的乘积
    for ($j = 1; $j -le 9; ++$j) {
        $worksheet.Cells($i + 1, $j + 1) = $i * $j
    }
}

#excel 读取数据
for ($i = 1; $i -le 10; ++$i) 
{
    for ($j = 1; $j -le 10; ++$j) {
        Write-Host -NoNewline $worksheet.Cells($i, $j).Text "`t"
    }
    Write-Host
}

#创建图表
$chart=$worksheet.Shapes.AddChart2().Chart

#为图表指定数据源
$chart.SetSourceData($worksheet.Range('a1', 'j10'))

#最后一步
$chartTypes = [Microsoft.Office.Interop.Excel.XLChartType]
$chart.ChartType = $chartTypes::xlColumnClustered

#饼状图
$chartTypes = [Microsoft.Office.Interop.Excel.XLChartType]
$chart = $worksheet.Shapes.AddChart2().Chart
$chart.SetSourceData($worksheet.Range('a1', 'j10'))
$chart.ChartType = $chartTypes::xlPie
$chart.ApplyDataLabels(5)