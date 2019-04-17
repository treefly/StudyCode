#Get-ChildItem 和 Get-Item 命令可以获取已经存在的文件和目录。你也可以创建自己的文件和目录，重命名它们，给它们填充内容，复制它们，移动它们，当然也可以删除它们。

#创建新目录
#创建一个新目录最方便的方式是使用MD函数，它内部调用的是New-Item命令，指定参数–type的值为“Directory”：
# "md"是一个内置的函数用来创建新目录
md Test1    
# "New-Item"，也可以做这些，但是得多花点功夫
New-Item Test23 -type Directory

#只要test和Subdirectory目录都不存在，就会创建三个子目录。
md test\subdirectory\somethingelse



#创建新文件
#可能之前你已经使用过New-Item来创建过文件，但是它们完全是空的：
New-Item "new file.txt" -type File

#文件通常会在你保存数据时，自动被创建。因为空文件一般没多大用处。此时重定向和Out-File，Set-Content这两个命令可以帮助你：
#信息存入文本文件
Dir > info1.txt
Dir | Out-File info2.txt
Dir | Set-Content info3.txt
Set-Content info4.txt (Get-Date)#将任何内容写入文本文件


#事实证明在操作上重定向和Out-File非常的类似：当PowerShell转换管道结果时，文件的内容就像它在控制台上面输出的一样。（将对象输出）
#Set-Content呢，稍微有所不同。它在文件中只列出目录中文件的名称列表,因为在你使用Set-Content时，PowerShell不会自动将对象转换成文本输入。
#相反，Set-Content会从对象中抽出一个标准属性。上面的情况下，这个属性就是Name了。

#比如你手动使用ConvertTo-HTML将管道结果转换后，Out-File和Set-Content会殊途同归。
Dir | ConvertTo-HTML | Out-File report1.htm
Dir | ConvertTo-HTML | Set-Content report2.htm

#如果你想决定对象的那个属性应当显示在HTML页面中，可以使用第5章中提到的Select-Object 在对象转换成HTML前过滤属性。
Dir | Select-Object name, length, LastWriteTime |ConvertTo-HTML | Out-File report.htm
.\report.htm


#在重定向的过程中，控制台的编码会自动指定特殊字符在文本中应当如何显示。你也可以在使用Out-File命令时，使用-encoding参数来指定。
#如果你想将结果导出为逗号分割符列表，可以使用Export-CSV代替Out-File。
#你可以使用双重定向和Add-Content向一个文本文件中追加信息。

#将所有内容替换
Set-Content info.txt "First line" 
# 在内容最后追加
"Second line" >> info.txt
#追加
Add-Content info.txt "Third line"
#读取数据信息
Get-Content info.txt

#双箭头重定向可以工作，但是文本中显示的字符有间隔。
#重定向操作符通常使用的是控制台的字符集，如果你的文本中碰巧同时包含了ANSI和Unicode字符集，可能会引起意外的结果。
Set-Content，Add-Content和Out-File这几条命令，而不使用重定向，可以有效地规避前面的风险。这三条命令都支持-encoding参数，你可以用它来选择字符集。

#创建新驱动器
#PowerShell允许你创建新的驱动器。并且不会限制你只创建基于网络的驱动器。你还可以使用驱动器作为你的文件系统中重要目录，甚至你自定义的文件文件系统的一个方便的快捷方式。

#使用New-PSDrive命令来创建一个新的驱动器。可以像下面那样创建一个网络驱动器。

New-PSDrive -name network -psProvider FileSystem -root \\127.0.0.1\share

dir network:
  
New-PSDrive desktop FileSystem `
([Environment]::GetFolderPath("Desktop")) | out-null
New-PSDrive docs FileSystem `
([Environment]::GetFolderPath("MyDocuments")) | out-null
#更改当前目录为桌面时，只须输入：
Cd desktop:

#使用Remove-PSDrive来删除你创建的驱动器。如果该驱动器正在使用则不能删除。注意在使用New-PSDrive和Remove-PSDrive创建或删除驱动器时，指定的字母不能包含冒号，但是在使用驱动器工作时必须指定冒号。
Remove-PSDrive desktop

#读取文本文件的内容
#使用Get-Content可以获取文本文件的内容：
Get-Content $env:windir\windowsupdate.log

#如果你知道文件的绝对路径，还可以使用变量符号这个快捷方式读取文本内容：
${c:\windows\windowsupdate.log}


#Get-Content 逐行读取文本的内容，然后把文本的每一行传递给管道。因此，在你想读取一个长文件的前10行，应当适用Select-Object：
Get-Content $env:windir\windowsupdate.log | Select-Object -first 10

#使用Select-String可以过滤出文本文件中的信息。下面的命令行会从windowsupdate.log文件中过滤出包含”added update”短语的行。
Get-Content $env:windir\windowsupdate.log | Select-String "Added update"

#处理逗号分隔的列表
#在PowerShell中处理逗号分隔的列表文件中的信息时你须要使用Import-Csv文件。为了测试，先创建一个逗号分隔的文本文件。

Set-Content user.txt "Username,Function,Passwordage"
Add-Content user.txt "Tobias,Normal,10"
Add-Content user.txt "Martina,Normal,15"
Add-Content user.txt "Cofi,Administrator,-1"
Get-Content user.txt


Import-Csv user.txt


Import-Csv user.txt | echo -InputObject {$_.Username }
解析文本内容和提取文本信息
经常会碰到的一个任务就是解析原始数据，比如日志文件，从所有的数据中获取结构化的目标信息。比如日志文件：windowsupdate.log 它记录了windows更新的细节信息（在之前的例子中我们已经多次用到过这个小白鼠）。该文件还有大量数据，以至于乍一看没什么可读性。初步分析表明该文件是逐行存储的信息，并且每行的信息片段是以Tab字符分割的。

正则表达式为描述这类文件格式提供了最方便的方式，之前在第13章已经提到过。你可以按照下面的例子来使用正则表达式适当地描述文件indowsupdate.log的内容。

# 文本模式包含了6个Tab字符分割的数组
$pattern = "(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)"
# 输入日志
$text = Get-Content $env:windir\windowsupdate.log
# 从日志文件中提取出任意行（这里是第21行）
$text[20] -match $pattern
 
True
 
$matches
 

"On {0} this took place: {1}" -f $matches[1], $matches[6]
#On 2014-02-10 this took place:   * Added update {17A5424C-4C70-4BB4-8F83-66DABE5E7CA2}.201 to search result


1
2
3
4
5
6
7
8
9
10
11
12
13
# 这次子表达式拥有一个名称：
$pattern = "(?<Datum>.*)\t(?<time>.*)\t(?<Code1>.*)" + "\t(?<Code2>.*)\t(?<Program>.*)\t(?<Text>.*)"
# 输入日志:
$text = Get-Content $env:windir\windowsupdate.log
 
# 从日志中提取任意行来解析（这里取第21行）：
$text[20] -match $pattern
True
# 从 $matches 中获取信息
# 可以访问指定的名称:
$matches.time + $matches.text
 
11:30:42:237  * Added update {17A5424C-4C70-4BB4-8F83-66DABE5E7CA2}.201 to search result
现在你可以使用Get-Content一行一行读取整个日志文件了，然后使用上面的方式逐行处理。这意味着即使在一个庞大的文件中，你也可以快速，相对高效地收集所有你需要的信息。下面的例子正好会列出那些日志行的描述信息中包含了短语“woken up”的文本行。这可以帮助你找出一台机器是否曾经因为自动更新被从待机或者休眠模式唤醒。

Get-Content $env:windir\windowsupdate.log |
ForEach-Object { if ($_ -match "woken up") { $_ } }

如果进入循环，会将保存在$_中的完整文本行输出。你现在知道了如何使用正则表达式将一个包含特定信息片段的文本行分割成数组。

然而，还有第二种，更为精妙的方法，从文件中选择个别文本行，它就是Switch。你只需要告诉语句块，那个文件你想检查，那个模式你想匹配。剩下的工作就交给Switch吧！下面的语句会获取所有安装的自动更新日志。使用它比之前使用的Get-Content和ForEach-Object更快速。你只需要记住正则表达式“.*”代表任意数量的任意字符。

Switch -regex -file $env:windir\wu1.log {
	'START.*Agent: Install.*AutomaticUpdates' { $_ }}

2013-05-19 09:22:04:113 1248 1d0c Agent **START**
Agent: Installing updates [CallerId = AutomaticUpdates]
2013-05-24 22:31:51:046 1276 c38 Agent **START**
Agent: Installing updates [CallerId = AutomaticUpdates]
2013-06-13 12:05:44:366 1252 228c Agent **START**
Agent: Installing updates [CallerId = AutomaticUpdates]
如果你想找到其它程序的更新，比如SMS或者Defender。只需要在你的正则表达式中使用“SMS”或者“Defender”替换“automatic updates”即可。事实上，Switch可以接受多个模式，按照下面声明在花括号中的那样，依赖多个模式进行匹配。这就意味着只需几行代码，就可以找出多个程序的更新。

# 为结果创建一个哈希表:
result = @{Defender=0; AutoUpdate=0; SMS=0}
# 解析更新日志，并将结果保存在哈希表中:
Switch -regex -file $env:windir\wu1.log
{
'START.*Agent: Install.*Defender' { $result.Defender += 1 };
'START.*Agent: Install.*AutomaticUpdates' { $result.AutoUpdate +=1 };
'START.*Agent: Install.*SMS' { $result.SMS += 1}
}

# 输出结果:
$result

Name		Value
----		-----
SMS		0
Defender	1
AutoUpdate 	8
读取二进制的内容
不是所有的文件都包含文本。有时，我们需要读取二进制文件中的信息。正常情况下一个文件的扩展名扮演的很重要的角色。因为它决定了Windows使用什么程序来打开这个文件。然而在许多二进制文件中，文件头也紧密的集成到文件中。这些文件头包含了该文件是属于那一类文件的内部类型名称。借助于参数-readCount和-totalCount，Get-Content可以获取这些“魔法字节”。参数-readCount指明每次读取多少字节，-totalCount决定了你想从文件中读取的总的字节数。当前情况下，你需要从文件中读取的应当是前4个字节。

1
2
3
4
5
6
7
8
9
10
11
12
13
function Get-MagicNumber ($path)
{
Resolve-Path $path | ForEach-Object {
$magicnumber = Get-Content -encoding byte $_ -read 4 -total 4
$hex1 = ("{0:x}" -f ($magicnumber[0] * `
256 + $magicnumber[1])).PadLeft(4, "0")
$hex2 = ("{0:x}" -f ($magicnumber[2] * `
256 + $magicnumber[3])).PadLeft(4, "0")
[string] $chars = $magicnumber| %{ if ([char]::IsLetterOrDigit($_))
{ [char] $_ } else { "." }}
"{0} {1} '{2}'" -f $hex1, $hex2, $chars
}
}
Get-MagicNumber "$env:windir\explorer.exe"
4d5a 9000 'M Z . .'
Explorer的前四个字节为4d, 5a, 90, 和 00或者已经列出的文本MZ。这是Microsoft DOS的开发者之一Mark Zbikowski的简称。所以，标记MZ就代表了可执行的程序。这个标记和图片文件的标记不同：

PS> Get-MagicNumber "$env:windir\Web\Wallpaper\Scenes\*"
ffd8 ffe0 'ÿ Ø ÿ à'
ffd8 ffe0 'ÿ Ø ÿ à'
ffd8 ffe0 'ÿ Ø ÿ à'
ffd8 ffe0 'ÿ Ø ÿ à'
ffd8 ffe0 'ÿ Ø ÿ à'
ffd8 ffe0 'ÿ Ø ÿ à'
如你所见，Get-Content也可以读取二进制文件，一次只读一个字节。参数-readCount指定每一步读取多少个字节。-totalCount指定总共要读取的字节数，一旦给它赋值为-1，它会从头到尾读取所有文件内容。你可以通过将数据输出为十六进制来预览可执行文件。因为纯二进制文本不易阅读。

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
function Get-HexDump($path,$width=10, $bytes=-1)
{
$OFS=""
Get-Content -encoding byte $path -readCount $width -totalCount $bytes | ForEach-Object {
$characters = $_
if (($characters -eq 0).count -ne $width)
{
$hex = $characters | ForEach-Object {
" " + ("{0:x}" -f $_).PadLeft(2,"0")}
$char = $characters | ForEach-Object {
if ([char]::IsLetterOrDigit($_))
{ [char] $_ } else { "." }}
"$hex $char"
}
}
}
PS> Get-HexDump $env:windir\explorer.exe -width 15 -bytes 150
 4d 5a 90 00 03 00 00 00 04 00 00 00 ff ff 00 MZ..........ÿÿ.
 00 b8 00 00 00 00 00 00 00 40 00 00 00 00 00 ...............
 e0 00 00 00 0e 1f ba 0e 00 b4 09 cd 21 b8 01 à.....º....Í...
 4c cd 21 54 68 69 73 20 70 72 6f 67 72 61 6d LÍ.This.program
 20 63 61 6e 6e 6f 74 20 62 65 20 72 75 6e 20 .cannot.be.run.
 69 6e 20 44 4f 53 20 6d 6f 64 65 2e 0d 0d 0a in.DOS.mode....
 24 00 00 00 00 00 00 00 93 83 28 37 d7 e2 46 ...........7.âF
 64 d7 e2 46 64 d7 e2 46 64 de 9a c2 64 9d e2 d.âFd.âFdÞ.Âd.â
移动和复制文件和目录
Move-Item 和 Copy-Item用来执行移动和拷贝操作。它们也支持通配符。比如下面的脚本会将你家目录下的的所有PowerShell脚本文件复制到桌面上：

1
Copy-Item $home\*.ps1 ([Environment]::GetFolderPath("Desktop"))
但是，只有在家目录当下的脚本会被复制。幸亏Copy-Item还有一个参数-recurse，这个参数的效果类似Dir中的效果。如果你的初始化目录不包含任何目录，它也不会工作。

1
Copy-Item -recurse $home\*.ps1 ([Environment]::GetFolderPath("Desktop"))
使用Dir也可以复制所有PowerShell脚本到你的桌面，让我们先给你找出这些脚本，然后将结果传递给Copy-Item：

1
2
Dir -filter *.ps1 -recurse | ForEach-Object {
Copy-Item $_.FullName ([Environment]::GetFolderPath("Desktop")) }
小技巧：你可能被诱惑去缩减脚本行，因为文件对象整合了一个CopyTo()方法。

1
2
Dir -filter *.ps1 -recurse | ForEach-Object {
$_.CopyTo([Environment]::GetFolderPath("Desktop")) }
但是结果可能会出错，因为CopyTo()是一个低级的函数。它需要文件的目标路径也被复制。因为你只是想复制所有文件到桌面，你已经指定了目标路径的目录。CopyTo()会尝试将文件复制这个精确的字符串路径（桌面）下，但是肯定不会得逞，因为桌面是一个已经存在的目录了。相反的Copy-Item就聪明多了：如果目标路径是一个目录，它就会把文件复制到这个目录下。

此时，你的桌面上可能已经堆满了PowerShell脚本，最好的方式是将它们保存到桌面的一个子目录中。你需要在桌面上创建一个新目录，然后从桌面到这个子目录中移动所有的脚本。

1
2
3
$desktop = [Environment]::GetFolderPath("Desktop")
md ($desktop + "\PS Scripts")
Move-Item ($desktop + "\*.ps1") ($desktop + "\PS Scripts")
此时，你的桌面又恢复了往日的整洁，也把脚本安全的保存到桌面了。

重命名文件和目录
使用Rename-Item你可以给文件或者目录换个名字。但是这样做时要格外小心，因为如果把某些系统文件给重命名了，可能会导致系统瘫痪。甚至你只是更改了某些文件的扩展名，也会导致它们不能正常打开或者显示它们的一些属性。

1
2
3
4
5
6
Set-Content testfile.txt "Hello,this,is,an,enumeration"
# 在默认编辑器中打开文件:
.\testfile.txt
# 在Excel中打开文件:
Rename-Item testfile.txt testfile.csv
.\testfile.csv
批量重命名
因为Rename-Item可以在管道中的语句块中使用，这就给一些复杂的任务提供了令人惊讶的方便的解决方案。比如，你想将一个目录的名称和它的子目录的名称，包括目录下的文件的名称中所有的“x86”词语移除掉。下面的命令就够了：

1
2
Dir | ForEach-Object {
Rename-Item $_.Name $_.Name.replace("-x86", "") }
然而，上面的命令会实际上会尝试重命名所有的文件和目录，即使你找的这个词语在文件名中不存在。产生错误并且非常耗时。为了大大提高速度，可是使用Where-Object先对文件名进行过滤，然后对符合条件的文件进行重命名，可以将速度增长50倍：（荔非苔注：为什么是50倍呢？我不知道。）

1
2
Dir | Where-Object { $_.Name -contains "-x86" } | ForEach-Object {
Rename-Item $_.Name $_.Name.replace("-x86", "") }
更改文件扩展名
如果你想更改文件的扩展名，首先需要意识到后果：文件随后会识别为其它文件类型，而且可能被错误的应用程序打开，甚至不能被任何应用程序打开。下面的命令会把当前文件夹下的所有的PowerShell脚本的后缀名从“.ps1”改为“.bak”。

1
2
3
4
5
6
Dir *.ps1 | ForEach-Object { Rename-Item $_.Name `
([System.IO.Path]::GetFileNameWithoutExtension($_.FullName) + `
".bak") -whatIf }
What if: Performing operation "Rename file" on Target
"Element: C:\Users\Tobias Weltner\tabexpansion.ps1
Destination: C:\Users\Tobias Weltner\tabexpansion.bak".
由于-whatIf参数的缘故，一开始语句只会表明可能会执行重命名操作。

整理文件名
数据集往往随着时间的增长而增长。如果你想整理一个目录，你可以给定所有的文件一个统一的名称和序号。你可以从文件的某些具体的属性中合成文件名。还记得上面在桌面上为PowerShell脚本创建的那个子目录吗？让我们对它里面的PowerShell脚本以数字序号重命名吧。

1
2
3
Dir $directory\*.ps1 | ForEach-Object {$x=0} {
Rename-Item $_ ("Script " + $x + ".ps1"); $x++ } {"Finished!"}
Dir $directory\*.ps1
删除文件和目录
使用Remove-Item和别名Del可以删除文件和目录，它会不可恢复的删除文件和目录。如果一个文件属于只读文件，你需要指定参数-force ：

# 创建示例文件:
$file = New-Item testfile.txt -type file
# 文件不是只读:
$file.isReadOnly
False
# 激活只读属性:
$file.isReadOnly = $true
$file.isReadOnly
True
# 只读的文件需要指定-Force参数才能顺利删除:
del testfile.txt
Remove-Item : Cannot remove item C:\Users\Tobias Weltner\testfile.txt: Not enough permission to perform operation.
At line:1 char:4
+ del <<<< testfile.txt
del testfile.txt -force
Table
删除目录内容
如果你只想删除某个目录下的内容而保留目录本身，可以使用通配符。比如下面的脚本行会删除Recent目录下的内容，对应于启动菜单中的“My Recent Documents”。因为删除文件夹是一件掉以轻心就会产生严重后果的事情，所有你可以使用-whatIf参数模拟一下删除过程，看看可能会发生什么。

1
2
$recents = [Environment]::GetFolderPath("Recent")
del $recents\*.* -whatIf
如果你已经确认你的命令操作无误，将上面语句中的-whatif去掉即可删除这些文件。另一方面，如果你仍然不是很确定，可以使用-confirm，它会在每次删除操作执行前向你确认。

删除目录和它的内容
如果一个目录被删除了，它里面所有的内容都会丢失。在你尝试去删除一个文件夹连同它的内容时，PowerShell都会请求你的批准。这样是为了防止你无意间销毁大量数据。只有空目录才不需要请求确认信息。

# 新建一个测试目录:
md testdirectory

Directory: Microsoft.PowerShell.Core\FileSystem::C:\Users\Tobias Weltner\Sources\docs

Mode LastWriteTime Length Name
---- ------------- ------ ----
d---- 13.10.2007 13:31 testdirectory

# 在目录中新建一个文件
Set-Content .\testdirectory\testfile.txt "Hello"

# 删除目录 directory:
del testdirectory

Confirm
The item at "C:\Users\Tobias Weltner\Sources\docs\testdirectory" has children
and the Recurse parameter was not specified. If you continue, all children
will be removed with the item. Are you sure you want to continue?
|Y| Yes |A| Yes to All |N| No |L| No to All |S| Suspend |?| Help (default is"Y"):