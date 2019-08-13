#
# Name       : 25_CS_compo.ps1
# Description: PowerShell script designed to build the Wearable Viewer Remote Communication System.
#              - Code signing script for components
#

#
# Parameter
#   -CSTool     : path to code sign tool
#   -dbgprint   : print some debug messages
#
param(
    [string]$CSTool,
    [switch]$dbgprint
)

#----- Constants -----#
# common script
$COMMON_SCRIPT_FILE = ".\00_common.ps1"

# Get script path
$ScriptPath = $null
try
{
    $ScriptPath = (Get-Variable MyInvocation).Value.MyCommand.Path
    $ScriptDir = Split-Path -Parent $ScriptPath
}
catch {}


#
# Code signing - compo
#
function CodeSignCompo( $CodeSignTool )
{
    if( $dbgprint ){ Write-Host "(DBG)CodeSignCompo(IN)" }

    # copy list file for edit
    $src_path = $ScriptDir + "\" + $CS_FILELIST_RCS
    correctCompo $src_path $target_folder_rootpath_cswork $dbgprint

    $src_path = $ScriptDir + "\" + $CS_FILELIST_LAUNCHER
    correctCompo $src_path $target_folder_rootpath_cswork $dbgprint

    Write-Host "  Code signing operation(RCS)."
        # edit - RCS
        $list_file_rcs = $target_folder_rootpath_cswork + "\" + $CS_FILELIST_RCS

        $dst_path = $working_rootpath + "\" + $WVRCS_FOLDER + "\"

        $dst_path_front = $dst_path + "x64\" + $INSTALL_FOLDER_FRONT_END + "(Release)"
        $file_data = ( Get-Content $list_file_rcs ) -creplace "PATH_TO_TARGET_FILE_FRONT", $dst_path_front
        Set-Content $list_file_rcs $file_data

        $dst_path_back = $dst_path + "x64\" + $INSTALL_FOLDER_BACK_END + "(Release)"
        $file_data = ( Get-Content $list_file_rcs ) -creplace "PATH_TO_TARGET_FILE_BACK", $dst_path_back
        Set-Content $list_file_rcs $file_data

        $dst_path = $target_folder_rootpath_rcs_cswork + "\"

        $dst_path_front = $dst_path + "x64\" + $INSTALL_FOLDER_FRONT_END + "(Release)"
        $file_data = ( Get-Content $list_file_rcs ) -creplace "PATH_TO_OUTPUT_FOLDER_FRONT", $dst_path_front
        Set-Content $list_file_rcs $file_data

        $dst_path_back = $dst_path + "x64\" + $INSTALL_FOLDER_BACK_END + "(Release)"
        $file_data = ( Get-Content $list_file_rcs ) -creplace "PATH_TO_OUTPUT_FOLDER_BACK", $dst_path_back
        Set-Content $list_file_rcs $file_data

        # Special - TosRCInitialize
        $dst_path = $working_rootpath + "\FrontEnd\TosRCInitialize\bin\x64\Release"
        $file_data = ( Get-Content $list_file_rcs ) -creplace "PATH_TO_TARGET_FILE_INSTALLER", $dst_path
        Set-Content $list_file_rcs $file_data

        $dst_path = $target_folder_rootpath_installer + "\FrontEnd" 
        $file_data = ( Get-Content $list_file_rcs ) -creplace "PATH_TO_OUTPUT_FOLDER_INSTALLER", $dst_path
        Set-Content $list_file_rcs $file_data

        # Signing - RCS
        $CodeSignOp = " /list " + $list_file_rcs + " /silent"
        do_extcmd $CodeSignTool $CodeSignOp $dbgprint

    Write-Host "  Code signing operation(Launcher)."
        # edit - Launcher
        $list_file_launcher = $target_folder_rootpath_cswork + "\" + $CS_FILELIST_LAUNCHER

        $dst_path = $working_rootpath + "\Launcher\Components"
        $file_data = ( Get-Content $list_file_launcher ) -creplace "PATH_TO_TARGET_FILE", $dst_path
        Set-Content $list_file_launcher $file_data

        $dst_path = $target_folder_rootpath_launcher_cswork + "\Components"
        $file_data = ( Get-Content $list_file_launcher ) -creplace "PATH_TO_OUTPUT_FOLDER", $dst_path
        Set-Content $list_file_launcher $file_data

        # Signing - Launcher
        $CodeSignOp = " /list " + $list_file_launcher + " /silent"
        do_extcmd $CodeSignTool $CodeSignOp $dbgprint

    if( $dbgprint ){ Write-Host "(DBG)CodeSignCompo(OUT)" }
}

#
# Copy - compo
#
function CopyCompoForInstaller
{
    if( $dbgprint ){ Write-Host "(DBG)CopyCompoForInstaller(IN)" }

    # For RCS version
    $src_path = $working_rootpath + "\" + $WVRCS_FOLDER + "\*"
    $dst_path = $target_folder_rootpath_rcs_cswork + "\"
    folderCleanUp $dst_path $dbgprint
    correctCompo $src_path $dst_path $dbgprint

    # For Launcher version
    $src_path = $working_rootpath + "\Launcher\Components\*"
    $dst_path = $target_folder_rootpath_launcher_cswork + "\Components\"
    folderCleanUp $dst_path $dbgprint
    correctCompo $src_path $dst_path $dbgprint

    if( $dbgprint ){ Write-Host "(DBG)CopyCompoForInstaller(OUT)" }
}


#----------------------------------------
# Main script entry point
#----------------------------------------
#clear
Write-Host "`r`n<<<<< 25_CS_compo >>>>>"
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

# Copy component files
CopyCompoForInstaller

# check environment
if( $CSTool -ne "" )
{
    if( Test-Path -path $CSTool )
    {
        # Code signing - component
        CodeSignCompo $CSTool
    }
    else
    {
        Write-Host "  No code signing tool."
    }
}


#----- finished !! -----
Write-Host "`r`n<< FINISHED - 25_CS_compo >>"
$end_time = Get-Date

Write-Host "  Operation start time:"$start_time
Write-Host "  Operation end time  :"$end_time
Write-Host "`r`n"

exit $ReturnCode
