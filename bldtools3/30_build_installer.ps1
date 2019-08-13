#
# Name       : 30_build_installer.ps1
# Description: PowerShell script designed to build the Wearable Viewer Remote Communication System.
#              - build installers
#

#
# Parameter
#   -dbgprint   : print some debug messages
#
param(
    [switch]$dbgprint
)

#----- Constants -----#
# common script
$COMMON_SCRIPT_FILE = ".\00_common.ps1"

# path to build tools
$BLD_COMMAND_DEVENV = "devenv.exe"
# build option
$BUILD_TYPE_DEVENV = "Rebuild"
# build mode
$BUILD_MODE_LIST = "Release"
# platform list
$BUILD_PLATFORM_LIST = "x64"

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
# Build Installer
#
function build_installer
{
    if( $dbgprint ){ Write-Host "(DBG)build_installer(IN)" }

    mklogfolder $target_folder_rootpath_log

    # Build mode
    $bld_mode = "Release"

    # build
    foreach( $compo_inst in $COMPONENTS_LIST_INSTALL )
    {
        $part_of_project = $compo_inst.Split("\",2);
        $target_project_path = $working_rootpath + "\" + $compo_inst + "\" + $part_of_project[1]+".vdproj"

        # check project file
        if( Test-Path $target_project_path )
        {
            # log file
            $log_file_name = $target_folder_rootpath_log + "\installer-" + $app_version + "-" + $part_of_project[0] + "-" + $bld_mode+".xml"

            # Build option
            $bld_option = '"' + $target_project_path + '" /' + $BUILD_TYPE_DEVENV + " " + $bld_mode + " /projectconfig " + $bld_mode + " /Log " + $log_file_name
            #$bld_option = "/"+$BUILD_TYPE_DEVENV+" "+$bld_mode+' "'+$target_project+'" /Log '+$log_file_name

            # Build installer
            do_build $BLD_COMMAND_DEVENV $target_project_path $bld_option $log_file_name $dbgprint
        }
    }

    if( $dbgprint ){ Write-Host "(DBG)build_installer(OUT)" }
}



#----------------------------------------
# Main script entry point
#----------------------------------------
#clear
Write-Host "`r`n<<<<< 03_build_installer  >>>>>"
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

# Set build environment
Write-Host "`r`n[STEP1] Set - build environment"
setBuildEnvironment $dbgprint

if( $dbgprint ){ Write-Host "    (DBG)COMPONENTS_LIST_INSTALL:"$COMPONENTS_LIST_INSTALL }

# Build Installers
Write-Host "`r`n[STEP2] Build - installer"
build_installer


#----- finished !! -----
Write-Host "`r`n<< FINISHED - 30_build_installer >>"
$end_time = Get-Date

Write-Host "  Operation start time:"$start_time
Write-Host "  Operation end time  :"$end_time
Write-Host "`r`n"

exit $ReturnCode
