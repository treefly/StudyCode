#add dll
[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
#$content =  Get-Content C:\Users\vvvv\Desktop\Code\DemoFIle\ReadTxtFIle\ReadTxtFIle\bin\Debug\sqlString.txt
#连接数据库
$connectionStr = "Server= 172.20.10.4;Uid=root;Pwd=123456;database=test;"
$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
$connection.ConnectionString = $connectionStr
$connection.Open()

#开启检测
write-host '设置：开启检测设置 set profiling = 1'
$insertcommand = New-Object MySql.Data.MySqlClient.MySqlCommand
$insertcommand.Connection = $connection
$insertcommand.CommandText ="set profiling = 1"
$insertcommand.executenonquery()



Write-Host '插入sql语句 '
$insertcommand = New-Object MySql.Data.MySqlClient.MySqlCommand
$insertcommand.Connection = $connection

#批量制造sql语句
$fileNum  = 0
#$FilePath = "C:\Users\vvvv\Desktop\Sql\Sql.txt";
#$FilePath="C:\Users\vvvv\Desktop\Powershell\mysql\sql语句.ps1"
#$dataList = @(Get-Content $FilePath )
$dataList =Get-ChildItem -Path "C:\Users\vvvv\Desktop\Code\MysqlDataDemo\MysqlDataDemo\bin\Debug\ss"
foreach ($content in $dataList)
{
   $cccc = Get-Content $content.FullName
   write-host "-----------------------" 
   #write-host $content
   $insertcommand.CommandText = $cccc
   $insertcommand.executenonquery()
}

write-host 'sql拼写完成'

#执行MySQL


 
#查询数据
$querysql    = "show profiles;"
$command     = New-Object MySql.Data.MySqlClient.MySqlCommand($querysql, $connection)
$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
$dataSet     = New-Object System.Data.DataSet
$recordCount = $dataAdapter.Fill($dataSet)
$dataSet.Tables[0] | format-table -auto|Out-File "ExcuteSql.txt"

#Write-Host 'Press Any Key!' -NoNewline
#$null = [Console]::ReadKey('?')
#关闭连接
$connection.Close()



