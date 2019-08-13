#Get-ChildItem==Dir
Dir *.ps1

#你只对一个目录下的项目名称感兴趣，使用-Name参数
Dir -name

#Powershell code
Get-ChildItem

#当你想搜索整个子目录时，可以使用-recurce参数。
Dir *.ps1 -recurse

#指定一个过滤条件
Dir  -filter *.ps1 -recurse

Dir  -include *.ps1 -recurse

#-filter的执行效率明显高于-include：原因在于-include支持正则表达式，从内部实现上就更加复杂，
#而-filter只支持简单的模式匹配。这也就是为什么你可以使用-include进行更加复杂的过滤
(Measure-Command {Dir  -filter *.ps1 -recurse}).TotalSeconds

(Measure-Command {Dir  -include *.ps1 -recurse}).TotalSeconds

 #-filter 查询所有以 "[A-F]"打头的脚本文件，屁都没找到
Dir  -filter [a-f]*.ps1 -recurse

#-include 能够识别正则表达式，所以可以获取a-f打头，以.ps1收尾的文件
Dir  -include [a-f]*.ps1 -recurse

#与-include相反的是-exclude。在你想排除特定文件时，可以使用-exclude
Dir  -recurse -include *.bmp,*.png,*.jpg, *.gif

#例子会获取你家目录下比较大的文件，指定文件至少要100MB大小
Dir $home -recurse | Where-Object { $_.length -gt 100MB }

#文件的FileInfo信息：
$file = Dir C:\Users\vvvv\Desktop\Cmd\file2.txt
$file | Format-List *

#获取文件的属性
$file.Attributes
$file.CreationTime

#获取文件的3种方式
$file1 = Dir C:\Users\vvvv\Desktop\Cmd\file2.txt
$file2 = Get-Childitem C:\Users\vvvv\Desktop\Cmd\file2.txt
$file3 = Get-Item C:\Users\vvvv\Desktop\Cmd\file2.txt

# Dir 或者 Get-Childitem 获取 一个目录下的内容:
$directory1 = Dir c:\windows
$directory2 = Get-Childitem c:\windows
# Get-Item 获取的是目录对象本身:
$directory3 = Get-Item c:\windows

$directory1
$directory2
$directory3

# 只列出目录::
Dir | Where-Object { $_ -is [System.IO.DirectoryInfo] }
Dir | Where-Object { $_.PSIsContainer }
Dir | Where-Object { $_.Mode.Substring(0,1) -eq "d" }
# 只列出文件:
Dir | Where-Object { $_ -is [System.IO.FileInfo] }
Dir | Where-Object { $_.PSIsContainer -eq $false}
Dir | Where-Object { $_.Mode.Substring(0,1) -ne "d" }