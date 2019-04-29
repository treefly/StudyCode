param (
    $rootPath  = $env:ProgramFiles +"\dynaEdge\Vision DE Suite",   #需要查看并保存文件证书的文件夹

    #C:\Users\vvvv\Documents\Project\VdsNew\cmd\04241918_Signed\04241905_NeedSign\3.0.0.9\NeedSignFile
    #$rootPath  = "C:\Users\vvvv\Documents\Project\VdsNew\VDS_WorkCode\VDS3.0\VdsFrontApp\output\ForInstaller\DERCS\x64\DERCS Front-end(Release)",   #需要查看并保存文件证书的文件夹
    $storePath = $env:USERPROFILE  +"\Desktop\signature-" + (Get-Date -Format 'yyyymmddhhmmss') +".csv",  #结果存储路径
    $psTableList = @()
)



#获取当前文件所在路径--绝对路径
#$x= $MyInvocation.MyCommand.Definition
#获取绝对路径的父路径
#$x = Split-Path -Parent $MyInvocation.MyCommand.Definition

#查找环境变量：powershell 把环境变量都存储在env：中
#环境变量列表
#ls env:
#Get-ChildItem env:

#使用某个环境变量
#$env:windir


if(-not(Test-Path $storePath))
{
   Write-Host "Please check the file path is exists :" $storePath
}
else
{
    Get-ChildItem $rootPath -Recurse -File | ForEach-Object -Process{
    if(Test-Path $_.FullName)
    {
        #数字签字 检查输出到table
        $result     = Get-Authenticodesignature -FilePath $_.FullName -ErrorAction SilentlyContinue
        $signerCert = $result.SignerCertificate
        $cert       = New-Object System.Security.Cryptography.x509Certificates.X509Certificate2($signerCert)

        $SubjectName=($cert.SubjectName.Name -split ",")[0]
        $IssuerName =($cert.IssuerName.Name -split ",")[0]
        $table = @{"Filename"=$_.FullName; "颁发给"=$SubjectName; "颁发者"=$IssuerName}
     
        $pstable = New-Object -TypeName PSObject -Prop $table
    
        $psTableList += $pstable
    }

   }

   $pstablelist | Export-CSV $storePath -Encoding UTF8
}




<#
$files = Get-ChildItem -Path $rootPath -recurse -File
foreach ($file in $files) {
    $filePath = $rootPath + "\" + $file
    $result = Get-AuthenticodeSignature -FilePath $filePath -ErrorAction SilentlyContinue
    $signerCert = $result.SignerCertificate

    $cert = New-Object System.Security.Cryptography.x509Certificates.X509Certificate2($signerCert)

    $SubjectName = ($cert.SubjectName.Name -split ",")[0]
    $IssuerName = ($cert.IssuerName.Name -split ",")[0]

    $table = @{"Filename"=$file; "颁发给"=$SubjectName; "颁发者"=$IssuerName}
    #$table = @{"Filename"=$file; "SubjectName"=$SubjectName; "IssuerName"=$IssuerName}
    $pstable = New-Object -TypeName PSObject -Prop $table
    
    $psTableList += $pstable

    #$cert.SubjectName | Select-Object -Property Name
}
#>

<#
Get-ChildItem $srcdir -recurse -File | ForEach-Object -Process{
   $targetFile =  Join-Path $neeDsignFile $_.FullName.Substring($srcdir.Length)
   #文件存在，替换为新的
   if( (Test-Path $targetFile))
   {
        #如果目标文件夹不存在，先创建
        $targetDir = Split-Path $targetFile
        if(-not(Test-Path $targetDir)) 
        {
           #创建文件路径
           mkdir $targetDir
        }
        Copy-Item -Path $_.FullName -Destination $targetFile
        Write-Host $_.FullName  '-----Copy File To-------' $targetFile
    }
}
#>