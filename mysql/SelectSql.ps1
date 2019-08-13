#add dll
[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")

function Get-RandomString() {
    param(
    [int]$length=10,
    # 这里的[int]是类型指定
    [char[]]$sourcedata
    )

    for($loop=1; $loop –le $length; $loop++) {
            $TempPassword+=($sourcedata | GET-RANDOM | %{[char]$_})
    }
    return $TempPassword
}


#连接数据库
$connectionStr = "Server= 172.20.10.4;Uid=root;Pwd=123456;database=smartfactory;"
$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
$connection.ConnectionString = $connectionStr
$connection.Open()



#开启检测
write-host '设置：开启检测设置 set profiling = 1'
$insertcommand = New-Object MySql.Data.MySqlClient.MySqlCommand
$insertcommand.Connection = $connection
$insertcommand.CommandText ="set profiling = 1"
$insertcommand.executenonquery()

$selectSql="select * from mira_detect_session_result_modulodate where  id >30 and id<50;"

#执行MySQL
Write-Host '插入sql语句 '
$insertcommand = New-Object MySql.Data.MySqlClient.MySqlCommand
$insertcommand.Connection = $connection
$insertcommand.CommandText = $selectSql
$insertcommand.executenonquery()

 
#查询数据
$querysql    = "show profiles;"
$command     = New-Object MySql.Data.MySqlClient.MySqlCommand($querysql, $connection)
$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
$dataSet     = New-Object System.Data.DataSet
$recordCount = $dataAdapter.Fill($dataSet)
$dataSet.Tables[0] | format-table -auto

Write-Host 'Press Any Key!' -NoNewline
$null = [Console]::ReadKey('?')
#关闭连接
$connection.Close()




<#

  
#关于执行sql 语句耗时
#设置profiling       
#SET profiling=1
#select * from mira_role;
#SHOW profiles;
#SHOW profile FOR QUERY 1;
#查看数据库版本
#how variables like "%version%"; 或者 select version();

总结一下，查看mysql语句运行时间的方法。

方法一： show profiles。

1. Show profiles是5.0.37之后添加的，要想使用此功能，要确保版本在5.0.37之后。

Query Profiler是MYSQL自带的一种query诊断分析工具，通过它可以分析出一条SQL语句的性能瓶颈在什么地方。通常我们是使用的explain,以及slow query log都无法做到精确分析，

但是Query Profiler却可以定位出一条SQL语句执行的各种资源消耗情况，比如CPU，IO等，以及该SQL执行所耗费的时间等。

查看数据库版本方法：show variables like "%version%"; 或者 select version();

2.确定支持show profile 后，查看profile是否开启，数据库默认是不开启的。变量profiling是用户变量，每次都得重新启用。

查看方法： show variables like "%pro%";
设置开启方法： set profiling = 1;
再次查看show variables like "%pro%"; 已经是开启的状态了。

3.可以开始执行一些想要分析的sql语句了，执行完后，show profiles;即可查看所有sql的总的执行时间。

show profile for query 1 即可查看第1个sql语句的执行的各个操作的耗时详情。
show profile cpu, block io, memory,swaps,context switches,source for query 6;可以查看出一条SQL语句执行的各种资源消耗情况，比如CPU，IO等
show profile all for query 6 查看第6条语句的所有的执行信息。
mysql> set profiling=0

方法二： timestampdiff来查看执行时间。

这种方法有一点要注意，就是三条sql语句要尽量连一起执行，不然误差太大，根本不准
set @d=now();
select * from comment;
select timestampdiff(second,@d,now());
如果是用命令行来执行的话，有一点要注意，就是在select timestampdiff(second,@d,now());后面，一定要多copy一个空行，不然最后一个sql要你自己按回车执行，这样就不准了.

#>