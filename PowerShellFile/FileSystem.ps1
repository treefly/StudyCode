
<#
PowerShell文件系统（一）前言
PowerShell文件系统（二）访问文件和目录
PowerShell文件系统（三）导航文件系统
PowerShell文件系统（四）使用目录和文件工作
PowerShell文件系统（五）管理访问权限
使用Get-ChildItem列出目录的内容。预定义的别名为Dir和ls，Get-ChildItem执行了一些很重要的任务：
#>
<#
因为Windows管理员一般在实践中，使用Get-ChildItem的别名Dir，所以接下来的例子都会使用Dir。另外ls（来自UNIX家族）也可以代替下面例子中的Dir或者Get-ChildItem。
列出目录的内容
Dir会列出当前目录的内容。如果你在Dir后跟了一个目录，它的内容也会被列出来，如果你使用了-recurse参数，Dir会列出所有子目录的内容。当然，也允许使用通配符。
#>

#例如，你想列出当前目录下的所有PowerShell脚本，输入下面的命令：
Dir *.ps1

#Dir甚至能支持数组，能让你一次性列出不同驱动器下的内容。下面的命令会同时列出PowerShell根目录下的PowerShell脚本和Windows根目录下的所有日志文件。
Dir $pshome\*.ps1, $env:windir\*.log

#如果你只对一个目录下的项目名称感兴趣，使用-Name参数，Dir就不会获取对象(Files和directories)，只会以纯文本的形式返回它们的名称。
Dir -name

#注意：一些字符在PowerShell中有特殊的意义，比如方括号。方括号用来访问数组元素的。这也就是为什么使用文件的名称会引起歧义。
#当你使用-literalPath参数来指定文件的路径时，所有的特殊字符被视为路径片段，PowerShell解释器也不会处理。
#荔非苔注：Dir 默认的参数为-Path。假如你当前文件夹下有个文件名为“.\a[0].txt“，因为方括号是PowerShell中的特殊字符，会解释器被解析。
#为了能正确获取到”.\a[0].txt”的文件信息，此时可以使用-LiteralPath参数，它会把你传进来的值当作纯文本。

PS> Get-ChildItem .\a[0].txt
PS> Get-ChildItem -Path .\a[0].txt
PS> Get-ChildItem -LiteralPath .\a[0].txt


#当你想搜索整个子目录时，可以使用-recurce参数。但是注意，下面例子执行时会失败。
Dir *.ps1 -recurse

#你需要了解一点-recurse如何工作的细节来理解为什么会发生上面的情况。Dir总是会获取目录中的内容为文件对象或者目录对象。
#如果你设置了-recurse开关，Dir会递归遍历目录对象。但是你在上面的例子中使用的通配符只获取扩展名为ps1的文件，没有目录，
#所以-recurse会跳过。这个概念刚开始使用时可能有点费解，但是下面的使用通配符例子能够递归遍历子目录，正好解释了这点。

#在这里，Dir获取了根目录下所有以字母“D”打头的项目。递归开关起了作用，那是因为这些项目中就包含了目录。
Dir $home\d* -recurse

#在高版本中的PowerShell 中Dir *.ps1 -recurse也是可以工作的。

#过滤和排除标准
#怎样递归列出同类型的所有文件
Dir $home -filter *.ps1 -recurse

#除了-filter，还有一个参数乍一看和-filter使用起来很像： -include
Dir $home -include *.ps1 -recurse

# -filter的执行效率明显高于-include：
# -filter 查询所有以 "[A-F]"打头的脚本文件，没找到
Dir $home -filter [a-f]*.ps1 -recurse

# -include 能够识别正则表达式，所以可以获取a-f打头，以.ps1收尾的文件
Dir $home -include [a-f]*.ps1 -recurse
#与-include相反的是-exclude。在你想排除特定文件时，可以使用-exclude。


Dir $home -recurse -include *.bmp,*.png,*.jpg, *.gif
#具体为当你的过滤条件没有正则表达式时，使用-filter，可以显著提高效率。


#下面的例子会获取你家目录下比较大的文件，指定文件至少要100MB大小。
Dir $home -recurse | Where-Object { $_.length -gt 100MB }



#Get-Item是访问单个文件的另外一个途径
$file = Dir c:\autoexec.bat
$file = Get-Childitem c:\autoexec.bat
$file = Get-Item c:\autoexec.bat


# Dir 或者 Get-Childitem 获取 一个目录下的内容:
$directory = Dir c:\windows
$directory = Get-Childitem c:\windows
$directory

# Get-Item 获取的是目录对象本身:
$directory = Get-Item c:\windows
$directory
 

$list1 = Dir $env:windir\system32\*.dll
$list2 = Dir $env:programfiles -recurse -filter *.dll
$totallist = $list1 + $list2
$totallist | ForEach-Object {
$info =
[system.diagnostics.fileversioninfo]::GetVersionInfo($_.FullName);
"{0,-30} {1,15} {2,-20}" -f $_.Name, `
$info.ProductVersion, $info.FileDescription
}

# 只列出目录::
Dir | Where-Object { $_ -is [System.IO.DirectoryInfo] }
Dir | Where-Object { $_.PSIsContainer }
Dir | Where-Object { $_.Mode.Substring(0,1) -eq "d" }
# 只列出文件:
Dir | Where-Object { $_ -is [System.IO.FileInfo] }
Dir | Where-Object { $_.PSIsContainer -eq $false}
Dir | Where-Object { $_.Mode.Substring(0,1) -ne "d" }


#Where-Object也可以根据其它属性来过滤。
#比如下面的例子通过管道过滤2007年5月12日后更改过的文件：
Dir | Where-Object { $_.CreationTime -gt [datetime]::Parse("May 12, 2007") }


#也可以使用相对时间获取2周以内更改过的文件：
Dir | Where-Object { $_.CreationTime -gt (Get-Date).AddDays(-14) }
