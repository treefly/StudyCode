
<#-------命令行绑定参数--------------
#命令行绑定
# .\Params.ps1 -省份 "江苏" -市 "徐州" -aAaa "123a" -镇 12

[CmdletBinding()]
Param(
    [string]$省份,
    #脚本命令行参数绑定例子 powershell传教士 制作 分享     
    [string]$市,
    [string]$aAaa = 'k',
    [Int32] $镇 = 17
)

$a =  $省份 + $市 + $镇
write-host $a
write-host $aAaa



$message="First :" + $args[0] +",Second"+$args[1] +",Three :" +$args[2] 
Write-Host $message 
#>

<#-----------定义参数-----
#define params
param($a,$b)

#define params with type
param([string]$a,[int]$b)


write-host "Hello,$a"

write-host "nihao,$b"
#>

function aaa 
{
    [CmdletBinding()]
    Param(
        [string]$今天好心情_老熊请吃,
        #脚本命令行参数绑定例子 powershell传教士 制作 分享
        [int32]$a = 123     
    )

    write-host "老熊今天请吃 ？ $今天好心情_老熊请吃 ！！！"
    Write-Host $a
}

Import-Module .\Params.ps1 
MethodWithParams -Name "asgd" -Age 12321

function MethodWithParams 
{
    [CmdletBinding()]
    Param(
        [string]$Name,
        #脚本命令行参数绑定例子 powershell传教士 制作 分享
        [int32]$Age = 123     
    )

    write-host "Your name is "  $Name  "！！！"
    Write-Host  $Age
}