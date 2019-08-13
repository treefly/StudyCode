#
# Name       : 40_post_build.ps1
# Description: PowerShell script designed to build the Wearable Viewer Remote Communication System.
#              - archive folders
#              - send result files(ToDo)
#              - count up the version number
#              - git operation(ToDo)
#

#
# Parameter
#   -uploadcompo : 
#   -ver_up      : 
#   -dbgprint    : print some debug messages
#
param(
    [switch]$uploadcompo,
    [switch]$ver_up,
    [switch]$dbgprint
)

#----- Constants -----#
$COMMON_SCRIPT_FILE = ".\00_common.ps1"

#----- Valiables -----#
$app_version = ""

# Get script path
$ScriptPath = $null
try
{
    $ScriptPath = (Get-Variable MyInvocation).Value.MyCommand.Path
    $ScriptDir = Split-Path -Parent $ScriptPath
}
catch {}


#
# Copy - compo for release
#
function CopyCompoForRelease
{
    if( $dbgprint ){ Write-Host "(DBG)CopyCompoForRelease(IN)" }

    # For RCS version
    $src_path = $target_folder_rootpath_rcs_cswork + "\*"
    $dst_path = $target_folder_rootpath_compo + "\"
    folderCleanUp $target_folder_rootpath_compo $dbgprint
    correctCompo $src_path $dst_path $dbgprint

    # For Launcher version
    $src_path = $target_folder_rootpath_launcher_cswork + "\Components\*"
    $dst_path = $target_folder_rootpath_launcher_compo + "\Components\"
    folderCleanUp $target_folder_rootpath_launcher_compo $dbgprint
    correctCompo $src_path $dst_path $dbgprint

    foreach( $target_module in $LAUNCHER_ADD_MODULE )
    {
        $src_path = $working_rootpath + "\Launcher\" + $target_module

        $part_of_path = $target_module.Split("\",2);
        $dst_path = $target_folder_rootpath_launcher_compo + "\" + $part_of_path[0]

        if( $part_of_path[1] -ne $null )
        {
            correctCompo $src_path $dst_path
        }
        else
        {
            Copy-Item $src_path $dst_path
        }

        if( $part_of_path[0] -eq $LAUNCHER_SAMPLE_APP )
        {
            $dst_path = $target_folder_rootpath_launcher_release + "\" + $part_of_path[0]
            folderCleanUp $dst_path $dbgprint
            correctCompo $src_path $dst_path $dbgprint
        }
    }

    # Special - TosRCLoggerlib.dll
    $src_path = $target_folder_rootpath_rcs_cswork + "\x64\" + $INSTALL_FOLDER_FRONT_END + "(Release)\TosRCLoggerlib.dll"
    $dst_path = $target_folder_rootpath_installer + "\FrontEnd"
    correctCompo $src_path $dst_path $dbgprint

    if( $dbgprint ){ Write-Host "(DBG)CopyCompoForRelease(OUT)" }
}

#
# Archive folders
#
function archiveFolders()
{
    if( $dbgprint ){ Write-Host "(DBG)archiveFolders(IN)" }

    $archive_target = $target_folder_rootpath_log, $target_folder_rootpath_compo,
                    $target_folder_rootpath_source, $target_folder_rootpath_installer,
                    $target_folder_rootpath_launcher_release, $target_folder_rootpath_launcher_compo,
                    $target_folder_rootpath_launcher_installer

    foreach( $target_folder in $archive_target )
    {
        if( $dbgprint ){ Write-Host "    (DBG)target:"$target_folder }
        if( Test-Path $target_folder )
        {
            Compress-Archive -Force -Path $target_folder -DestinationPath $target_folder".zip"
            moveCompo $target_folder".zip" $target_folder_rootpath_release
        }
        else
        {
            Write-Host "[archiveFolder]"
            Write-Host "    No Target Folder:"$target_folder
        }
    }

    if( $dbgprint ){ Write-Host "(DBG)archiveFolders(OUT)" }
}

#
# send package
#
function sendPackage()
{
    if( $dbgprint ){ Write-Host "(DBG)sendPackage(IN)" }

    if( $dbgprint ){ Write-Host "(DBG)sendPackage(OUT)" }
}

#
# send packages
#
function sendPackages
{
    if( $dbgprint ){ Write-Host "(DBG)sendPackages(IN)" }

    if( $dbgprint ){ Write-Host "(DBG)sendPackages(OUT)" }
}

#
# count up - version number
#
function countUp_version
{
    if( $dbgprint ){ Write-Host "(DBG)countUp_version(IN)" }

    if( Test-Path $VERSION_FILE )
    {
        $version_information = Get-Content $VERSION_FILE
        $build_ver_info = ""
        foreach( $line_data in $version_information )
        {
            # skip - comment line and null line
            if( $line_data -match "^$" ){ continue }
            if( $line_data -match "^\s*#" ){ continue }

            $verinfo = $line_data.Split( "=", 2 )
            if( $verinfo[0] -eq "VERSION" )
            {
                $app_version = $verinfo[1]
            }
            if( $verinfo[0] -eq "REVISION" )
            {
                $revision_no = $verinfo[1]
                $revision_no_info = $line_data
            }
        }
        $new_revision_no = [int]$revision_no + 1
        $new_revision_no_info = "REVISION=" + $new_revision_no

        Write-Host "`r`n[Update - Version]"
        Write-Host "    Current Revision No.:"$revision_no_info
        Write-Host "    Next Revision No.   :"$new_revision_no_info

        $file_data = ( Get-Content $VERSION_FILE ) -creplace $revision_no_info, $new_revision_no_info
        Set-Content $VERSION_FILE $file_data
    }

    if( $dbgprint ){ Write-Host "(DBG)countUp_version(OUT)" }
}

#
# git operation
#
function postGitOperation
{
    if( $dbgprint ){ Write-Host "(DBG)postGitOperation(IN)" }

    # get git hash
    $git_hash = git rev-parse HEAD

    # make git tag string
    $date_data = (Get-Date).ToString("yyyyMMdd")
    $git_tag = "wvrcs-v"+$app_version+"_"+$date_data

    # make git tag command
    $git_tag_command0 = ""
    $git_tag_command1 = "git tag "+$git_tag+" "+$git_hash
    $git_tag_command2 = "git push origin tag "+$git_tag

    # git tag command file name
    $git_tag_cmd_file = $working_rootpath + "\" + $OUTPUT_FOLDER + "\gittag_"+$app_version+".txt"

    if( $dbgprint )
    {
        Write-Host "  (DBG)hash:"$git_hash
        Write-Host "  (DBG)tag:"$git_tag
        Write-Host "  (DBG)Command0:"$git_tag_command0
        Write-Host "  (DBG)Command1:"$git_tag_command1
        Write-Host "  (DBG)Command2:"$git_tag_command2
        Write-Host "  (DBG)Filename:"$git_tag_cmd_file
    }

    # write to file
    Set-Content $git_tag_cmd_file $git_tag_command0
    Add-Content $git_tag_cmd_file $git_tag_command1
    Add-Content $git_tag_cmd_file $git_tag_command2

    # move to release folder
    moveCompo $git_tag_cmd_file $target_folder_rootpath_release

    if( $dbgprint ){ Write-Host "(DBG)postGitOperation(OUT)" }
}


#----------------------------------------
# Main script entry point
#----------------------------------------
#clear
Write-Host "`r`n<<<<< 40_post_build >>>>>"
$start_time = Get-Date

# change folder
Set-Location $ScriptDir

# check and load common script file
if( Test-Path $COMMON_SCRIPT_FILE )
{
    . $COMMON_SCRIPT_FILE
}
else
{
    Write-Host "`r`n<< ERROR >> [ No common file ( -1 ) ]"
    exit -1
}

# Initial Process
initialProcess $dbgprint

# Delete binary files
deleteBinFolder $dbgprint

# Copy - compo for release
CopyCompoForRelease

# Delete *.obj and Signed.log files
Get-ChildItem $target_folder_rootpath_launcher -Recurse -include "obj" | Remove-Item -Recurse -Force
Get-ChildItem $target_folder_rootpath_launcher -Recurse -include "Signed.log" | Remove-Item -Recurse -Force
Get-ChildItem $target_folder_rootpath_wvrcs -Recurse -include "Signed.log" | Remove-Item -Recurse -Force

# Archive
folderCleanUp $target_folder_rootpath_release
archiveFolders

# send packages
if( $uploadcompo )
{
    sendPackages
}

# count up - version number
if( $ver_up )
{
    countUp_version
}

# git operation
postGitOperation

#----- finished !! -----
Write-Host "`r`n<< FINISHED - 40_post_build >>"
$end_time = Get-Date

Write-Host "  Operation start time:"$start_time
Write-Host "  Operation end time  :"$end_time
Write-Host "`r`n"

exit $ReturnCode
