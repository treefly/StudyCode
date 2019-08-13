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

<#     插入几个基础的数据表
write-host '批量插入mira_line 1--100'
#批量插入mira_line 1--100
$sqlCount=100
$insert="insert into  mira_line (id,name,description,modify_time,current_line_model_id,deleted) 
         VALUES ";
for($i=1;$i -le $sqlCount;$i++)
{
   #生成随机字符串和数字
   $id                    = $i
   $name                  = Get-RandomString -length 14 -sourcedata (48..57 + 65..90 + 97..122)
   $description           = Get-RandomString -length 14 -sourcedata (48..57 + 65..90 + 97..122)
   $time                  = Get-Date
   $modify_time           = $now_time.ToString('yyyy-MM-dd hh:mm:ss')
   $current_line_model_id = $i
   $deleted               = get-random -inputobject 0,1
  
   $insert += "
          ($id,'$name','$description','$modify_time',$current_line_model_id, $deleted),"
}

$insert=$insert.SubString(0,$insert.Length-1)+" ;"
$insert| Out-File mira_line.txt
$insertcommand = New-Object MySql.Data.MySqlClient.MySqlCommand
$insertcommand.Connection = $connection
$insertcommand.CommandText =$insert
$insertcommand.executenonquery()
write-host '操作完成'


write-host '批量插入mira_machine_model 1--100'
#批量插入mira_machine_model 1--100
$insert="insert into  mira_machine_model (id,name,description,modify_time,deleted) 
         VALUES ";
for($i=1;$i -le $sqlCount;$i++)
{
   #生成随机字符串和数字
   $id                    = $i
   $name                  = Get-RandomString -length 14 -sourcedata (48..57 + 65..90 + 97..122)
   $description           = Get-RandomString -length 14 -sourcedata (48..57 + 65..90 + 97..122)
   $time                  = Get-Date
   $modify_time           = $now_time.ToString('yyyy-MM-dd hh:mm:ss')
   $deleted               = get-random -inputobject 0,1
  
   $insert += "
          ($id,'$name','$description','$modify_time', $deleted),"
}
$insert=$insert.SubString(0,$insert.Length-1)+" ;"
$insert| Out-File mira_machine_model.txt
$insertcommand = New-Object MySql.Data.MySqlClient.MySqlCommand
$insertcommand.Connection = $connection
$insertcommand.CommandText =$insert
$insertcommand.executenonquery()
write-host '操作完成'


write-host '批量插入mira_sn_jg 1--100'
#批量插入mira_sn_jg 1--100
$insert="insert into  mira_sn_jg (id,sn_no,jg_no,modify_time) 
         VALUES ";
for($i=1;$i -le $sqlCount;$i++)
{
   #生成随机字符串和数字
   $id                    = $i
   $sn_no                 = Get-random -Maximum 100 -Minimum 1
   $jg_no                 = Get-random -Maximum 100 -Minimum 1
   $time                  = Get-Date
   $modify_time           = $now_time.ToString('yyyy-MM-dd hh:mm:ss')
   $insert += "
          ($id,'$sn_no','$jg_no','$modify_time'),"
}
$insert=$insert.SubString(0,$insert.Length-1)+" ;"
$insert| Out-File mira_sn_jg.txt
write-host 'sql拼写完成'
$insertcommand = New-Object MySql.Data.MySqlClient.MySqlCommand
$insertcommand.Connection = $connection
$insertcommand.CommandText =$insert
$insertcommand.executenonquery()
write-host '操作完成'


write-host '批量插入mira_line_station 1--100'
#批量插入mira_line_station 1--100
$insert="insert into  mira_line_station (id,station_index,station_name,line_id,ip,port,camera_config,auto_upload_video,auto_upload_time,modify_time,deleted) 
         VALUES ";
for($i=1;$i -le $sqlCount;$i++)
{
   #生成随机字符串和数字
   $id                    = $i
   $station_index         = Get-random -Maximum 100 -Minimum 1
   $station_name          = Get-RandomString -length 14 -sourcedata (48..57 + 65..90 + 97..122)
   $line_id               = Get-random -Maximum 100 -Minimum 1
   $ip                    = "192.168.1."+$i
   $port                  = Get-random -Maximum 100 -Minimum 1
   $camera_config         = "config"
   $auto_upload_video     = Get-Random -InputObject 0,1
   $now_time              = Get-Date
   $auto_upload_time      = $now_time.ToString('yyyy-MM-dd hh:mm:ss')
   $modify_time           = $now_time.ToString('yyyy-MM-dd hh:mm:ss')
   $deleted               = Get-Random -InputObject 0,1
   $insert += "
          ($id,$station_index,'$station_name',$line_id,'$ip',$port,'$camera_config',$auto_upload_video,'$auto_upload_time','$modify_time',$deleted) ,"
}
$insert=$insert.SubString(0,$insert.Length-1)+" ;"
$insert| Out-File mira_line_station.txt
write-host 'sql拼写完成'
$insertcommand = New-Object MySql.Data.MySqlClient.MySqlCommand
$insertcommand.Connection = $connection
$insertcommand.CommandText =$insert
$insertcommand.executenonquery()
write-host '操作完成'



write-host '批量插入mira_line_model 1--100'
#批量插入mira_line_model 1--100
$insert="insert into  mira_line_model (id,line_id,model_id,modify_time,running,deleted) 
         VALUES ";
for($i=1;$i -le $sqlCount;$i++)
{
   #生成随机字符串和数字
   $id                    = $i
   $line_id               = Get-random -Maximum 100 -Minimum 1
   $model_id              = Get-random -Maximum 100 -Minimum 1
   $time                  = Get-Date
   $modify_time           = $now_time.ToString('yyyy-MM-dd hh:mm:ss')
   $running               = Get-Random -InputObject 0,1
   $deleted               = Get-random -inputobject 0,1
   $insert += "
          ($id,$line_id,$model_id,'$modify_time',$running, $deleted),"
}
$insert=$insert.SubString(0,$insert.Length-1)+" ;"
$insert| Out-File mira_line_model.txt
write-host 'sql拼写完成'
$insertcommand = New-Object MySql.Data.MySqlClient.MySqlCommand
$insertcommand.Connection = $connection
$insertcommand.CommandText =$insert
$insertcommand.executenonquery()
write-host '操作完成'



#批量插入mira_line_model_shift_history
$insert="insert into  mira_line_model_shift_history (shift_no,line_model_id,shift_time_start,shift_time_end,shift_duration,line_config_md5,hidden) 
         VALUES ";
for($i= 1;$i -le $sqlCount;$i++)
{
   #生成随机字符串和数字
   $shift_no                    = $i
   $line_model_id               = Get-random -Maximum 100 -Minimum 1
   $now_time                    = Get-Date
   $record_time                 = $now_time.ToString('yyyy-MM-dd hh:mm:ss')
   $shift_time_start            = $record_time
   $shift_time_end              = $record_time
   $shift_duration              = $i
   $line_config_md5             = $i
   $hidden                      = Get-random -inputobject 0,1
   $insert += "
          ($shift_no,$line_model_id,'$shift_time_start','$shift_time_end',$shift_duration, $line_config_md5,$hidden),"
}
$insert=$insert.SubString(0,$insert.Length-1)+" ;"
$insert| Out-File mira_line_model_shift_history.txt
write-host 'sql拼写完成'
$insertcommand = New-Object MySql.Data.MySqlClient.MySqlCommand
$insertcommand.Connection = $connection
$insertcommand.CommandText =$insert
$insertcommand.executenonquery()

#>
#批量制造sql语句
$sqlCount=100
$insert="insert into  mira_detect_session_result_modulodate (id,shift_no_id,record_time,date_time_begin,date_time_end,sn_no,ig_no,line_id,line_name,model_id,model_name,
 procedure_id,procedure_index,procedure_name,procedure_cfgpackage_md5,station_id,station_name,spent,detect_result,video_name,modify_time) VALUES ";
for($i=1;$i -le $sqlCount;$i++)
{
   $randomStr = Get-RandomString -length 14 -sourcedata (48..57 + 65..90 + 97..122)
   write-host "正是在拼第" + $i "条sql 语句"
   #生成随机字符串和数字
   $id                          = $i
   #$name                       = Get-RandomString -length 14 -sourcedata (48..57 + 65..90 + 97..122)
   $shift_no_id                 = Get-Random -Maximum 100 -Minimum 1
   $now_time                    = Get-Date
   $record_time                 = $now_time.ToString('yyyy-MM-dd hh:mm:ss')
   $date_time_begin             = $record_time
   $date_time_end               = $record_time
   $sn_no                       = Get-Random -Maximum 100 -Minimum 1
   $ig_no                       = Get-Random -Maximum 100 -Minimum 1
   $line_id                     = Get-Random -Maximum 100 -Minimum 1
   $line_name                   = $randomStr + "line_name"
   $model_id                    = $i
   $model_name                  = $randomStr + "model_name"
   $procedure_id                = $i
   $procedure_index             = $i 
   $procedure_name              = $randomStr + "procedure_name"
   $procedure_cfgpackage_md5    = $randomStr + "procedure_cfgpackage_md5"
   $staion_id                   = $i
   $station_name                = $randomStr + "station_name"
   $spent                       = $i
   $detect_result               = Get-Random -InputObject 0,1
   $video_name                  = $randomStr + "video_name"
   $modify_time                 = $now_time.ToString('yyyy-MM-dd hh:mm:ss')

   $insert += "
          ($id,$shift_no_id,'$record_time','$date_time_begin','$date_time_end',$sn_no,$ig_no,$line_id,'$line_name',$model_id,'$model_name',
           $procedure_id,$procedure_index,'$procedure_name','$procedure_cfgpackage_md5',$staion_id,'$station_name',$spent,$detect_result,'$video_name','$modify_time'),"
}
$insert=$insert.SubString(0,$insert.Length-1)+" ;"
$insert| Out-File mira_detect_session_result_modulodate.txt
write-host 'sql拼写完成'

#执行MySQL
Write-Host '插入sql语句 '
$insertcommand = New-Object MySql.Data.MySqlClient.MySqlCommand
$insertcommand.Connection = $connection
$insertcommand.CommandText = $insert
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