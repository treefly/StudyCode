#
# Name       : 99_UnS_compo.ps1
# Description: PowerShell script designed to build the Wearable Viewer Remote Communication System.
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

# build info
$BUILD_MODE_LIST = "Release"
# platform list
$BUILD_PLATFORM_LIST = "x64"
# build solution list
$TARGET_SOLUTION_LIST = "wvrcs"

# compo list
$COMPO_LIST_FILE = ".\compo_list.csv"

# Get script path
$ScriptPath = $null
try
{
    $ScriptPath = (Get-Variable MyInvocation).Value.MyCommand.Path
    $ScriptDir = Split-Path -Parent $ScriptPath
}
catch {}


#
# collect component
#
function collectCompo( $src_path, $dst_path, $bDbgprint )
{
    if( $bDbgprint ){ Write-Host "(DBG)collectCompo(IN)" }
    
    if( $bDbgprint ){
        Write-Host "   "$src_path
        Write-Host "      =>"$dst_path
    }

    if( !(Test-Path $dst_path) )
    {
        New-Item $dst_path -ItemType Directory
    }

    # copy
    Copy-Item $src_path $dst_path -Recurse

    if( $bDbgprint ){ Write-Host "(DBG)collectCompo(OUT)" }
}

#
# collect components for RCS
#
function collectForRCS
{
    if( $dbgprint ){ Write-Host "(DBG)collectForRCS(IN)" }

    # read component list
    $compo_list = Import-Csv $COMPO_LIST_FILE -Encoding Default

    # collect components
    for( $i = 0; $i -lt $compo_list.Length; $i++ )
    {
        if(( $compo_list[$i].Component ) -and ( $compo_list[$i].Flg -eq "1" ))
        {
            foreach( $bld_platform in $BUILD_PLATFORM_LIST )
            {
                foreach( $bld_mode in $BUILD_MODE_LIST )
                {
                    $src_path = $compo_list[$i].Path.Replace( "(Platform)", $bld_platform )
                    $src_path = $src_path.Replace( "(BuildType)", $bld_mode )
                    $src_path = $working_rootpath + "\" + $compo_list[$i].Folder + "\" + $src_path + "\" + $compo_list[$i].Component
                    if( Test-Path $src_path )
                    {
                        if( $compo_list[$i].Folder -eq "BackEnd" )
                        {
                            # "Back-end" and "Common" modules
                            $inst_folder = $INSTALL_FOLDER_BACK_END
                        }
                        else
                        {
                            # "Front-end" modules
                            $inst_folder = $INSTALL_FOLDER_FRONT_END
                        }

                        # 2steps copy
                        $dst_path = $target_folder_rootpath_cswork + "\" + $WVRCS_FOLDER + "\"
                        $dst_path += $bld_platform + "\" + $inst_folder + "(" + $bld_mode + ")\" + $compo_list[$i].Target

                        # collect component
                        collectCompo $src_path $dst_path $dbgprint

                        # additional collect component ("Common" modules to "Back-end")
                        if( $compo_list[$i].Folder -eq "Common" )
                        {
                            $inst_folder = $INSTALL_FOLDER_BACK_END
                            $dst_path = $target_folder_rootpath_cswork + "\" + $WVRCS_FOLDER + "\"
                            $dst_path += $bld_platform + "\" + $inst_folder + "(" + $bld_mode + ")\" + $compo_list[$i].Target
                            collectCompo $src_path $dst_path $dbgprint
                        }
                    }
                    else
                    {
                        # No target file
                        $ErrMessage = "No target file (" + $compo_list[$i].Component + ")"
                        printErrorMassageAndExit $ERR_CODE.NoTargetFile $ErrMessage
                    }
                }
            }
        }
    }

    $src_path = $working_rootpath + "\Common\Tool\*"
    $dst_path = $target_folder_rootpath_cswork + "\" + $WVRCS_FOLDER + "\x64\" + $INSTALL_FOLDER_FRONT_END + "(Release)\Tool"
    collectCompo $src_path $dst_path $dbgprint

    if( $dbgprint ){ Write-Host "(DBG)collectForRCS(OUT)" }
}


#----------------------------------------
# Main script entry point
#----------------------------------------
#clear
Write-Host "`r`n<<<<< 99_unsigned_compo >>>>>"
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


# collect Components for RCS version
folderCleanUp $target_folder_rootpath_cswork $dbgprint
collectForRCS 1


#----- finished !! -----
Write-Host "`r`n<< FINISHED - 99_unsigned_compo >>"
$end_time = Get-Date

Write-Host "  Operation start time:"$start_time
Write-Host "  Operation end time  :"$end_time
Write-Host "`r`n"

exit $ReturnCode
