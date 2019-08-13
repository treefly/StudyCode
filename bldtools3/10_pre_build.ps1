#
# Name       : 10_pre_build.ps1
# Description: PowerShell script designed to build the Wearable Viewer Remote Communication System.
#              - copy source tree to zip archive
#                (but it don't archive the source code in this process)
#              - set version information
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

# git
$GIT_RELATED_FILES = ".git", ".gitignore"
# modify zhangHaiLun
#$GIT_TARGET_REPOSITORY="vds20"
$GIT_TARGET_REPOSITORY="VdsFrontApp"

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
# copy source tree to zip archive
#
function copySourceTree
{
    if( $dbgprint ){ Write-Host "(DBG)copySourceTree(IN)" }

    Write-Host ">>  Copy source tree"

    deleteTargetFolder $target_folder_rootpath_source $dbgprint

    foreach( $target_file in $SOURCE_TREE_TARGET )
    {
        # make path to source folder
        $src_folder = $ScriptDir + "\..\..\" + $GIT_TARGET_REPOSITORY + "\" + $target_file

        # make path to target folder
        $part_of_project = $target_file.Split("\",2);
        if( $part_of_project[1] -eq "*" )
        {
            if( $dbgprint ){ Write-Host "  (DBG) part_of_project" }
            $dst_folder = $target_folder_rootpath_source + "\" + $part_of_project[0]
            if( !(Test-Path $dst_folder) )
            {
                New-Item $dst_folder -ItemType Directory
            }
        }
        else
        {
            if( $dbgprint ){ Write-Host "  (DBG) target_file" }
            $dst_folder = $target_folder_rootpath_source + "\" + $target_file
        }

        if( $dbgprint )
        {
            Write-Host "  (DBG)from:"$src_folder
            Write-Host "  (DBG)  to:"$dst_folder
        }
        else
        {
            Write-Host "   "$target_file
        }
        Copy-Item $src_folder $dst_folder -Recurse
    }

    Write-Host ""

    if( $dbgprint ){ Write-Host "(DBG)copySourceTree(OUT)`r`n" }
}

#
# set version info
#
function setVersionInfo
{
    if( $dbgprint ){ Write-Host "(DBG)setVersionInfo(IN)" }

    Write-Host ">>  Set version information"

    # for C# project
    foreach( $target_compo in $COMPONENTS_LIST )
    {
        $target_file = $working_rootpath +  "\" + $target_compo + "\Properties\" + $VERSION_TARGET_FILE + ".cs"
        if( $dbgprint )
        {
           Write-Host "   "$target_file
        }
        else
        {
            Write-Host "   "$target_compo"\Properties\"$VERSION_TARGET_FILE".cs"
        }

        # edit
        editVersionInfo $target_file
    }

    # for C/C++ project
    foreach( $target_compo in $COMPONENTS_LIST_CLANG )
    {
        $target_file = $working_rootpath +  "\" + $target_compo + "\" + $VERSION_TARGET_FILE + ".cpp"
        if( $dbgprint )
        {
           Write-Host "   "$target_file
        }
        else
        {
            Write-Host "   "$target_compo"\"$VERSION_TARGET_FILE".cpp"
        }

        editVersionInfo $target_file
    }

    Write-Host ""

    if( $dbgprint ){ Write-Host "(DBG)setVersionInfo(OUT)" }
}

function editVersionInfo( $target_ver_file )
{
    if( Test-Path $target_ver_file )
    {
        $file_data = ( Get-Content $target_ver_file ) -creplace $VERSION_TARGET, $app_version
        Set-Content $target_ver_file $file_data -Encoding UTF8
    }
    else
    {
        # No target file
        $ErrMessage = "No target file ("+$target_ver_file+")"
        printErrorMassageAndExit $ERR_CODE.NoTargetFile $ErrMessage
    }
}


#----------------------------------------
# Main script entry point
#----------------------------------------
#clear
Write-Host "`r`n<<<<< 10_pre_build >>>>>"
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

# copy source tree to zip archive
copySourceTree

# set version info
setVersionInfo


#----- finished !! -----
Write-Host "`r`n<< FINISHED - 10_pre_build >>"
$end_time = Get-Date

Write-Host "  Operation start time:"$start_time
Write-Host "  Operation end time  :"$end_time
Write-Host "`r`n"

exit $ReturnCode
