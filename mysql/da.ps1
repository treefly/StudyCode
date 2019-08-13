

function global:Build-VisualStudioSolution ($SolutionFilePath, $Configuration, $CleanFirst, $Platform )
{
    # Local Variables
    $MsBuild = $env:systemroot + "\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe";


    # Local Variables
    $fileinfo = ([System.IO.FileInfo]$SolutionFilePath) ;
    $SolutionFile = $fileinfo.Name;
    $BuildOutput = "BuildLogOutput.txt";
    $BuildLogFile=  $fileinfo.DirectoryName + "\msbuild.log"; # 这个名字是对应 /fl1
    $bOk = $true;
    write-host "SolutionFilePath : $SolutionFilePath";
    write-host "SolutionFile : $SolutionFile";
    write-host "BuildLog     : $BuildOutput";
    write-host "BuildLogFile : $BuildLogFile";

    try
    {

        # Clear first?
        if($CleanFirst)
        {
            write-host CleanFirst
            &$MsBuild $SolutionFilePath /t:clean /p:Configuration=$Configuration/v:minimal
        }

        write-host  "Building..." 
        $MsBuildArgs = "/p:Configuration=$Configuration"
        if ($Platform)
        {
            $Platform += ("/p:Platform="""+$Platform+"""") 
        }
        #/nologo

         &$MsBuild  $SolutionFilePath /t:build $Platform  $MsBuildArgs /verbosity:normal /clp:ShowEventId /flp:"Summary;Verbosity=normal;LogFile=$BuildLogFile"
        $ret = $?;
        if ($ret)
        {
            $bOk = $true;
        }
        else
        {
            $bOk = $false;
        }
    }
    catch
    {
        $bOk = $false;
        Write-Error ("Unexpect error occured while building " + $SolutionFile + ": " + $_.Exception.Message);
    }

}


#解决方案路径
$ret = Build-VisualStudioSolution -SolutionFilePath "C:\Users\vvvv\Desktop\Code\DemoFIle\textboxSelectAll\textboxSelectAll.sln" -Configuration "Debug" ;
if($ret)
{
    write-host  "编译成功！！！" 
}
else
{
    Write-Host "编译失败"
   
}

"Any key to exit"  ;
 Read-Host | Out-Null ;
 Exit -1

