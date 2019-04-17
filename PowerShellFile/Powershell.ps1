#以Get开头的命令        Get-Command -Verb Get
#查找名词部分是Help的命令 Get-Command -Noun Help
#列出所有命令            Get-Command *
#获取命令的帮助Get-Help 缩写为man  ： man cd 
#查找有关服务的命令     Get-Command -Noun service
#查找字母dy 开头的服务  Get-Service dy*
# Get-Location命令用于获取当前工作目录位置，它的别名是pwd:$current=pwd  $current
#实际上Get-location 返回的是一个对象 $current.Path
#Get-Member，别名是gm，用于获取对象的属性 Get-Location|Get-Member
#如果不再需要一个变量，可以使用Remove-Variable删除变量，它的别名是rv :Remove-Variable current


#比较运算符：大于（-gt），大于等于（-ge），小于（-lt），小于等于（-le），等于（-eq），不等于（-ne）几个。
#字符串匹配运算符：-like和-notlike用于?*这样的通配符。
'hello' -like '?ello'
'hello' -notlike '?ello'
#应用正则表达式  ：-match和-notmatch用于正则表达式。
'aabcc' -match 'a*b?c+'
#-contains查找序列中是否包含某个元素 
'hello','zhang3' -contains 'zhang3'
#-replace用于替换字符串中某个部分，当然正则表达式也是支持的
 'hello zhang3' -replace 'zhang3','yitian' 
#-split和-join用于将一个字符串分为几个子部分，或者将几个子部分组合为一个字符串。
#运算符都是大小写不敏感的，如果需要大小写敏感的功能，可以在运算符前面添加c前缀
 'yitian' -cmatch 'Yitian'
#逻辑运算符有与（-and）、或（-or）、非（-not或!）以及异或（xor）几个，并且支持短路计算。

#判断数据类型:。因此我们可以在脚本中判断数据的类型，只要使用-is或-isnot运算符即可，类型需要写到方括号中
3.14 -is [Double]
#重定向运算符：首先是>和>>运算符，用于将标准输出流重定向到文件，前者会覆盖已有文件，后者则是追加到已有文件末尾。
#日志级别，如果有使用过某些语言的日志框架的话，就很好理解了。在这里，2代表错误、3代表警告、4代表信息、5代表调试信息。
#n>和n>>运算符就是用于将对应级别的输出重定向到文件的，这两者的区别和前面相同。n>&1将对应级别的输出和标准输出一起重定向到文件。
#*>和*>>了，这两者将所有输出信息重定向到文件。
#Powershell使用Unicode编码来输出信息。如果你需要使用其他类型的编码，就不能使用重定向运算符了，而应该使用Out-File命令。

# &运算符将它后面的命令设置为后台运行，当运行的命令需要阻塞当前终端的时候很有用。

# .\\运算符用于执行一个脚本或命令。如果执行的是Powershell脚本，那么脚本会在自己的作用域中执行，也就是说在当前环境下无法访问被执行的脚本中的变量。

# []运算符用于转换变量的类型，比如说下面的代码，就将pi变量转换为了Float类型。
[Float]$pi = 3.14

#.运算符用于调用.NET对象的成员，它也可以用于执行脚本。

#::运算符用于调用类中的静态成员

# ..运算符用于创建一个范围闭区间.
 1..7
#-f运算符用于格式化数据
'My name is {0}， I am {1} years old' -f 'yitian',24

# $运算符可以将字符串内部的变量转换为实际的值，例如下面这样。
# 需要注意使用内插操作符的时候，外部字符串需要使用双引号，否则Powershell会直接输出字符串内容。
$name='yitian'
$age=24
"My name is $name, I am $age years old."

# @()运算符用于将一系列值转换为一个数组。假如在脚本中有一个函数可能返回0、1或多个值，就可以使用这个操作符，将一系列值合并为一个数组，方便后续处理。

# ,逗号运算符如果放置在单个值前面，就会创建一个包含这个值的单元素数组


#if 判断
$condition = $true

if ($condition -eq $true) {
    Write-Output "condition is $true"
}
elseif ($condition -ne $true ) {
    Write-Output "condition is $false"
}
else {
    Write-Output "other ocndition"
}


#switch 判断
$n = 4
switch ($n) {
    1 {"n is 1"}
    2 {"n is 2"}
    3 {"n is 3"}
    default {"n is others"}
}

#do 循环
$i = 0
do {
    $i++
    Write-Output $i
}while ($i -ne 3)

#while 循环
$i = 0
while ($i -lt 3) {
    Write-Output $i
    $i++
}

#for循环
for ($i = 0; $i -ne 3; $i++) {
    Write-Output $i
}


#foreach 循环
$array = @(1, 2, 3, 4)
foreach ($i in $array) {
    Write-Output $i
}
#foreach 一个特殊用法<command> | foreach {<beginning command_block>}{<middle command_block>}{<ending command_block>}


#定义函数
function hello {
    Write-Output 'Hello Powershell zhang'
}
hello

# 函数的参数
# 函数当然也可以带参数了，参数列表有两种写法：第一种是C风格的，参数列表写在函数名后面，使用小括号分隔开；
# 第二种方式是在方法体中，使用param关键字声明参数；
function Say-Hello ([string] $name) 
{
    Write-Output "Hello, $name"
}

function Say-Hello2 
{
    param([string] $name)
    Write-Output "Hello, $name"
}

#默认参数 Powershell也支持位置参数，它会把所有参数包装到$args数组中，所以我们可以通过这个变量访问所有位置的参数。
function Say-Hellos 
{
    $names = $args -join ','
    Write-Output "Hello, $names"
}

Say-Hellos 'yitian' 'zhang3' 'li4'

#开关参数
#开关参数没有类型，作用仅仅是标志是或者否。如果在使用函数的时候带上开关参数，那么它就是开的状态，否则就是关的状态。开关参数需要指定参数类型为switch。

function Answer-Hello ([switch] $yes) 
{
    if ($yes) {
        Write-Output "Hi"
    }
}

Answer-Hello -yes
Answer-Hello 

#函数返回值，只需要return 语句就可以了
function Add ([double]$a, [double]$b) 
{
    $c = $a + $b
    return $c
}

Add -a 3 -b 5