$start_time = Get-Date
$start_time = $start_time.ToString('yyyy-MM-dd hh:mm:ss')
Write-Host $start_time
function Get-RandomString() {
    param(
    [int]$length=10,
    # 这里的[int]是类型指定
    [char[]]$sourcedata
    )

    for($loop=1; $loop –le $length; $loop++) 
    {
        $TempPassword+=(  GET-RANDOM -InputObject $sourcedata | %{[char]$_})
    }
    return $TempPassword
}
#create sql 语句
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
   $line_name                   = $randomStr #+ "line_name"
   $model_id                    = $i
   $model_name                  = $randomStr #+ "model_name"
   $procedure_id                = $i
   $procedure_index             = $i 
   $procedure_name              = $randomStr #+ "procedure_name"
   $procedure_cfgpackage_md5    = $randomStr #+ "procedure_cfgpackage_md5"
   $staion_id                   = $i
   $station_name                = $randomStr #+ "station_name"
   $spent                       = $i
   $detect_result               = Get-Random -InputObject 0,1
   $video_name                  = $randomStr #+ "video_name"
   $modify_time                 = $now_time.ToString('yyyy-MM-dd hh:mm:ss')

   $insert += "
          ($id,$shift_no_id,'$record_time','$date_time_begin','$date_time_end',$sn_no,$ig_no,$line_id,'$line_name',$model_id,'$model_name',
           $procedure_id,$procedure_index,'$procedure_name','$procedure_cfgpackage_md5',$staion_id,'$station_name',$spent,$detect_result,'$video_name','$modify_time'),"
}

$end_time=Get-Date
$end_time= $end_time.ToString('yyyy-MM-dd hh:mm:ss')
Write-Host $end_time


$insert=$insert.SubString(0,$insert.Length-1)+" ;"
$insert| Out-File mira_detect_session_result_modulodate.txt
write-host 'sql拼写完成'