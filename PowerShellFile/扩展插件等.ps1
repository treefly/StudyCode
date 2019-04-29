#管理单元的扩展，需要先注册
#pssnapin
#获取可以用的管理单元列表
Get-pssnapin -Registered

#添加管理单元
Add-PSSnapin
#删除管理单元
Remove-PSSnapin

#
Get-PSProvider

#---新章节
Get-Process |Get-Member
Get-Process |gm

#gm 可以查看管道中的对象，gm 可以用在一个输出命令之后


#---对结果根据某一个属性进行排序，多个排序用，分割
Get-Process |Sort-Object -Property vm

#Sort-Object 别名sort
Get-Item |Sort-Object -Property name

#select-object
Get-Process | Select-Object Name，ID，VM，PM

#获取指定范围数据
Get-Process |Select-Object -First 1 -Last 10

#powershell 在执行最后 一个命令之前总是传递对象Object


<#
Get- Content .\computers. txt | Get- Service 当 运行 Get- Content 命令 时， 它 会 将 文本 文件 中的 计算机 名称 放入 管道 中。 之后 PowerShell 再 决定 如何 将 该数 据传 递给 Get- Service 命令。 但 PowerShell 一次 只能 使用 单个 参数 接收 传入 数据。 也就是说， PowerShell 必须 决定 由 Get- Service 的 哪个 参数 接收 Get- Content 的 输出 结果。 这个 决定 的 过程 就 称为 管道 参数 绑 定（ Pipeline parameter binding）， 这也 是 本章 主要 讲解 的 内容。 PowerShell 使用 两种 方法 将 Get- Content 的 输出 结果 传入 给 Get- Service 的 某个 参数。 该 Shell 尝试 使用 的 第一 种 方法 称为 ByValue； 如果 这种 方法 行不通， 它将 会 尝试 ByPropertyName。
#>
