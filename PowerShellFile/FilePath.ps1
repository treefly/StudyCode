
#如果你想导航到文件系统的另外一个位置，可以使用Set-Location或者它的别名Cd：

# 进入父目录 (相对路径):
Cd ..
# 进入当前盘的根目录 (相对路径):
Cd \
# 进入指定目录 (绝对路径):
Cd c:\windows
# 从环境变量中获取系统目录 (绝对路径):
Cd $env:windir
# 从普通变量中获取目录 (绝对路径):
Cd $home


#相对路径转换成绝对路径
#当你使用相对路径时，PowerShell必须将这些相对转换成绝对路径。在你使用相对路径执行一个文件或者一条命令时，该转换会自动发生。你也可以自己使用Resolve-Path命令来处理。
Resolve-Path .\a.png


#然而，Resolve-Path命令只有在文件确实存在时，才会有效。如果你的当前文件夹中没有一个名为a.png的是，Resolve-Path名讳报错。
#如果你指定的路径中包含了通配符，Resolve-Path还可以返回多个结果。下面的命令执行后，会获取PowerShell家目录下面的所有的ps1xml文件的名称。
Resolve-Path $pshome\*.ps1xml


#像Dir一样，Resolve-Path可以在下行函数中扮演选择过滤器的的角色。下面的例子会演示在记事本中打开一个文件进行处理。命令调用记事本程序通过Resolve-Path打开这个文件。
notepad.exe (Resolve-Path  $pshome\types.ps1xml).providerpath


#保存目录位置
#当前的目录可以使用Push-Location命令保存到目录堆栈的顶部，每一个Push-Location都可以将新目录添加到堆栈的顶部。使用Pop-Location可以返回。

#因此，如果你要运行一个任务，不得不离开当前目录，可以在运行任务前将用Push-Location存储当前路径，然后运行结束后再使用Pop-Location返回到当前目录。
# Cd $home总是会返回到你的家目录，Push-Location 和 Pop-Location支持堆栈参数。这使得你可以创建很多堆栈，比如一个任务，一个堆栈。Push-Location -stack job1会把当前目录保存到job1堆栈中，而不是标准堆栈中。当然在你想重新回到这个位置时，也需要在Pop-Location中指定这个参数-stack job1。



# 在桌面上创建一个快捷方式:
$path = [Environment]::GetFolderPath("Desktop") + "\EditorStart.lnk"
$comobject = New-Object -comObject WScript.Shell
$link = $comobject.CreateShortcut($path)
$link.targetpath = "notepad.exe"
$link.IconLocation = "notepad.exe,0"
$link.Save()
