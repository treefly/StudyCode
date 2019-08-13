#Get-ChildItem==Dir
Dir *.ps1

#��ֻ��һ��Ŀ¼�µ���Ŀ���Ƹ���Ȥ��ʹ��-Name����
Dir -name

#Powershell code
Get-ChildItem

#����������������Ŀ¼ʱ������ʹ��-recurce������
Dir *.ps1 -recurse

#ָ��һ����������
Dir  -filter *.ps1 -recurse

Dir  -include *.ps1 -recurse

#-filter��ִ��Ч�����Ը���-include��ԭ������-include֧��������ʽ�����ڲ�ʵ���Ͼ͸��Ӹ��ӣ�
#��-filterֻ֧�ּ򵥵�ģʽƥ�䡣��Ҳ����Ϊʲô�����ʹ��-include���и��Ӹ��ӵĹ���
(Measure-Command {Dir  -filter *.ps1 -recurse}).TotalSeconds

(Measure-Command {Dir  -include *.ps1 -recurse}).TotalSeconds

 #-filter ��ѯ������ "[A-F]"��ͷ�Ľű��ļ���ƨ��û�ҵ�
Dir  -filter [a-f]*.ps1 -recurse

#-include �ܹ�ʶ��������ʽ�����Կ��Ի�ȡa-f��ͷ����.ps1��β���ļ�
Dir  -include [a-f]*.ps1 -recurse

#��-include�෴����-exclude���������ų��ض��ļ�ʱ������ʹ��-exclude
Dir  -recurse -include *.bmp,*.png,*.jpg, *.gif

#���ӻ��ȡ���Ŀ¼�±Ƚϴ���ļ���ָ���ļ�����Ҫ100MB��С
Dir $home -recurse | Where-Object { $_.length -gt 100MB }

#�ļ���FileInfo��Ϣ��
$file = Dir C:\Users\vvvv\Desktop\Cmd\file2.txt
$file | Format-List *

#��ȡ�ļ�������
$file.Attributes
$file.CreationTime

#��ȡ�ļ���3�ַ�ʽ
$file1 = Dir C:\Users\vvvv\Desktop\Cmd\file2.txt
$file2 = Get-Childitem C:\Users\vvvv\Desktop\Cmd\file2.txt
$file3 = Get-Item C:\Users\vvvv\Desktop\Cmd\file2.txt

# Dir ���� Get-Childitem ��ȡ һ��Ŀ¼�µ�����:
$directory1 = Dir c:\windows
$directory2 = Get-Childitem c:\windows
# Get-Item ��ȡ����Ŀ¼������:
$directory3 = Get-Item c:\windows

$directory1
$directory2
$directory3

# ֻ�г�Ŀ¼::
Dir | Where-Object { $_ -is [System.IO.DirectoryInfo] }
Dir | Where-Object { $_.PSIsContainer }
Dir | Where-Object { $_.Mode.Substring(0,1) -eq "d" }
# ֻ�г��ļ�:
Dir | Where-Object { $_ -is [System.IO.FileInfo] }
Dir | Where-Object { $_.PSIsContainer -eq $false}
Dir | Where-Object { $_.Mode.Substring(0,1) -ne "d" }