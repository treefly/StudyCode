#Դ�ļ���
$srcdir = 'C:\Users\vvvv\Documents\Project\VDS_CodeFIle\cmd\VDS3.0\VdsFrontApp\output\ForInstaller\DERCS\x64\DERCS Front-end(Release)';
#�������õ�Ŀ���ļ���
$destdir = 'C:\Users\vvvv\Documents\Project\VDS_CodeFIle\cmd\SourceFile';

#��Ҫǩ�����ļ�·��
$neeDsignFile='C:\Users\vvvv\Documents\Project\VDS_CodeFIle\cmd\NeedSignFile';

#������õĴ˰汾�����ļ���������----��ֹ���ڳ���
Get-ChildItem $srcdir -recurse -File | ForEach-Object -Process{
        $targetFile =  Join-Path $destdir $_.FullName.Substring($srcdir.Length)        
        $targetDir  = Split-Path $targetFile
        if(-not(Test-Path $targetDir)) 
        {
           mkdir $targetDir
        }
        Copy-Item -Path $_.FullName -Destination $targetFile
        Write-Host $_.FullName  '-----Copy File To-------' $targetFile
}

#����Ҫǩ�����ļ�----�滻Ϊ���µ��ļ�������ǩ��

Get-ChildItem $srcdir -recurse -File | ForEach-Object -Process{
   $targetFile =  Join-Path $neeDsignFile $_.FullName.Substring($srcdir.Length)
   #�ļ����ڣ��滻Ϊ�µ�
   if( (Test-Path $targetFile))
   {
        #���Ŀ���ļ��в����ڣ��ȴ���
        $targetDir = Split-Path $targetFile
        if(-not(Test-Path $targetDir)) 
        {
           mkdir $targetDir
        }
        Copy-Item -Path $_.FullName -Destination $targetFile
        Write-Host $_.FullName  '-----Copy File To-------' $targetFile
    }
}

