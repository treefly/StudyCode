#
# Name       : 35_CS_installer.ps1
# Description: PowerShell script designed to build the Wearable Viewer Remote Communication System.
#              - Code signing script for installer
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
# Code signing - installer
#
function CodeSignInstaller( $CodeSignTool )
{
    if( $dbgprint ){ Write-Host "(DBG)CodeSignInstaller(IN)" }

    # copy list file for edit
    $src_path = $ScriptDir + "\" + $CS_FILELIST_INSTALLER
    correctCompo $src_path $target_folder_rootpath_cswork $dbgprint

    Write-Host "  Code signing operation(Installer)."
        # edit
        $list_file = $target_folder_rootpath_cswork + "\" + $CS_FILELIST_INSTALLER

        $dst_path = $working_rootpath + "\"

        $dst_path_front = $dst_path + "\" + $COMPONENTS_LIST_INSTALLER_RCS_FRONT + "\Release"
        $file_data = ( Get-Content $list_file ) -creplace "PATH_TO_TARGET_FILE_FRONT", $dst_path_front
        Set-Content $list_file $file_data

        $dst_path_back = $dst_path + "\" + $COMPONENTS_LIST_INSTALLER_RCS_BACK + "\Release"
        $file_data = ( Get-Content $list_file ) -creplace "PATH_TO_TARGET_FILE_BACK", $dst_path_back
        Set-Content $list_file $file_data

        $dst_path_front = $target_folder_rootpath_installer + "\FrontEnd"
        $file_data = ( Get-Content $list_file ) -creplace "PATH_TO_OUTPUT_FOLDER_FRONT", $dst_path_front
        Set-Content $list_file $file_data

        $dst_path_back = $target_folder_rootpath_installer + "\BackEnd"
        $file_data = ( Get-Content $list_file ) -creplace "PATH_TO_OUTPUT_FOLDER_BACK", $dst_path_back
        Set-Content $list_file $file_data

        $dst_path = $working_rootpath + "\" + $COMPONENTS_LIST_INSTALLER_LAUNCHER + "\Release"
        $file_data = ( Get-Content $list_file ) -creplace "PATH_TO_TARGET_FILE", $dst_path
        Set-Content $list_file $file_data

        $dst_path = $target_folder_rootpath_launcher_release + "\Installer"
        $file_data = ( Get-Content $list_file ) -creplace "PATH_TO_OUTPUT_FOLDER", $dst_path
        Set-Content $list_file $file_data

        # Signing - Installer
        $CodeSignOp = " /list " + $list_file + " /silent"
        do_extcmd $CodeSignTool $CodeSignOp $dbgprint

    #
    $src_path = $target_folder_rootpath_launcher_release + "\Installer\*"
    $dst_path = $target_folder_rootpath_launcher_installer
    correctCompo $src_path $dst_path $dbgprint

    if( $dbgprint ){ Write-Host "(DBG)CodeSignInstaller(OUT)" }
}

#
# Copy - installer
#
function CopyInstaller
{
    if( $dbgprint ){ Write-Host "(DBG)CopyInstaller(IN)" }

    # Build mode
    $bld_mode = "Release"

    # correct installers
    foreach( $compo_inst in $COMPONENTS_LIST_INSTALL )
    {
        $src_path = $working_rootpath + "\" + $compo_inst + "\" + $bld_mode + "\*"

        $part_of_project = $compo_inst.Split("\",2);
        if( $part_of_project[0] -eq "Launcher" )
        {
            # for Launcher version
            $dst_path = $target_folder_rootpath_launcher_installer
            $dst_path2 = $target_folder_rootpath_launcher_release + "\Installer"
            $dst_path_list = $dst_path, $dst_path2
        }
        else
        {
            # for Remote Comm version
            $dst_path_list = $target_folder_rootpath_installer + "\" + $part_of_project[0]
        }

        foreach( $dst_path in $dst_path_list)
        {
            # correct installer
            correctCompo $src_path $dst_path $dbgprint
        }
    }

    if( $dbgprint ){ Write-Host "(DBG)CopyInstaller(OUT)" }
}


#----------------------------------------
# Main script entry point
#----------------------------------------
#clear
Write-Host "`r`n<<<<< 35_CS_installer >>>>>"
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

# Copy installer file
CopyInstaller

# check environment
if( $CSTool -ne "" )
{
    if( Test-Path -path $CSTool )
    {
        # Code signing - installer
        CodeSignInstaller $CSTool
    }
    else
    {
        Write-Host "  No code signing tool."
    }
}


#----- finished !! -----
Write-Host "`r`n<< FINISHED - 35_CS_installer >>"
$end_time = Get-Date

Write-Host "  Operation start time:"$start_time
Write-Host "  Operation end time  :"$end_time
Write-Host "`r`n"

exit $ReturnCode
