#
# Name       : 20_build_compo.ps1
# Description: PowerShell script designed to build the Wearable Viewer Remote Communication System.
#              - build components
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
$BLD_COMMAND_MSBUILD = "MSBuild.exe"
# build option
$BUILD_TYPE_MSBUILD = "Rebuild"
# build mode
$BUILD_MODE_LIST = "Release"
# platform list
$BUILD_PLATFORM_LIST = "x64"
# build solution list
$TARGET_SOLUTION_LIST = "wvrcs"

# compo list
$COMPO_LIST_FILE = ".\compo_list.csv"

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
# Build Components
#
function build_components
{
    if( $dbgprint ){ Write-Host "(DBG)build_components(IN)" }

    mklogfolder $target_folder_rootpath_log

    # build
    foreach( $solution in $TARGET_SOLUTION_LIST )
    {
        $target_solution = $working_rootpath + "\" + $solution+".sln"
        if( $dbgprint ) { Write-Host "    (DBG) target_solution:"$target_solution }

        # check solution file
        if( Test-Path $target_solution )
        {
            foreach( $bld_platform in $BUILD_PLATFORM_LIST )
            {
                foreach( $bld_mode in $BUILD_MODE_LIST )
                {
                    # log file
                    $log_file_name = $target_folder_rootpath_log+"\"+$solution+"-"+$app_version+"-"+$bld_platform+"-"+$bld_mode+".log"

                    # build option
                    $bld_option = $target_solution+" /m /t:"+$BUILD_TYPE_MSBUILD+" /p:Configuration="+$bld_mode
                    $bld_option += " /p:Platform="+$bld_platform+" /flp:logfile="+$log_file_name

                    # build
                    do_build $BLD_COMMAND_MSBUILD $target_solution $bld_option $log_file_name $dbgprint
                }
            }
        }
        else
        {
            # No build information file
            printErrorMassageAndExit $ERR_CODE.NoSolutionFile "Solution file not found !!"
        }
    }

    if( $dbgprint ){ Write-Host "(DBG)build_components(OUT)" }
}

#
# Build - Components - RCS version !!
#
function build_components_rcs
{
    if( $dbgprint ){ Write-Host "(DBG)build_components_rcs(IN)" }

    # set module type
    setModuleType "RCS" $dbgprint

    # rebuild launcher app(TosRCHome).
    build_components

    if( $dbgprint ){ Write-Host "(DBG)build_components_rcs(OUT)" }
}

#
# Build - Components - Launcher version !!
#
function build_components_launcher
{
    if( $dbgprint ){ Write-Host "(DBG)build_components_launcher(IN)" }

    # set module type
    setModuleType "LAUNCHER" $dbgprint

    # rebuild launcher app(TosRCHome).
    build_components

    # reset module type
    setModuleType "RCS" $dbgprint

    if( $dbgprint ){ Write-Host "(DBG)build_components_launcher(OUT)" }
}

#
# correct components for RCS
#
function correctForRCS
{
    if( $dbgprint ){ Write-Host "(DBG)correctForRCS(IN)" }

    # read component list
    $compo_list = Import-Csv $COMPO_LIST_FILE -Encoding Default

    # correct components
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
                        $dst_path = $working_rootpath + "\" + $WVRCS_FOLDER + "\"
                        $dst_path += $bld_platform + "\" + $inst_folder + "(" + $bld_mode + ")\" + $compo_list[$i].Target

                        # correct component
                        correctCompo $src_path $dst_path $dbgprint

                        # additional correct component ("Common" modules to "Back-end")
                        if( $compo_list[$i].Folder -eq "Common" )
                        {
                            $inst_folder = $INSTALL_FOLDER_BACK_END
                            $dst_path = $working_rootpath + "\" + $WVRCS_FOLDER + "\"
                            $dst_path += $bld_platform + "\" + $inst_folder + "(" + $bld_mode + ")\" + $compo_list[$i].Target
                            correctCompo $src_path $dst_path $dbgprint
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
    $dst_path = $working_rootpath + "\" + $WVRCS_FOLDER + "\x64\" + $INSTALL_FOLDER_FRONT_END + "(Release)\Tool"
    correctCompo $src_path $dst_path $dbgprint

    if( $dbgprint ){ Write-Host "(DBG)correctForRCS(OUT)" }
}

#
# correct components for Launcher
#
function correctForLauncher
{
    if( $dbgprint ){ Write-Host "(DBG)correctForLauncher(IN)" }

    # read component list
    $compo_list = Import-Csv $COMPO_LIST_FILE -Encoding Default

    # correct components
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
                        if(( $bld_platform -eq "x64" ) -and ( $bld_mode -eq "Release" ) -and ( $compo_list[$i].FlgL -eq "1" ))
                        {
                            # 2steps copy
                            $dst_path = $working_rootpath + "\Launcher\Components\" + $compo_list[$i].Target

                            # correct component
                            correctCompo $src_path $dst_path $dbgprint
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

    if( $dbgprint ){ Write-Host "(DBG)correctForLauncher(OUT)" }
}

#
# make and correct setup file
#
function makeSetupFile
{
    if( $dbgprint ){ Write-Host "(DBG)makeSetupFile(IN)" }

    # set setup folder
    $setup_folder = $working_rootpath + "\" + $SETUP_WORK_FOLDER

    # target folder
    $dst_path = $target_folder_rootpath_installer + "\FrontEnd" 

    # set setup file path
    $setup_base_path = $setup_folder + "\" + $SETUP_BASE
    $setup_file_path = $setup_folder + "\" + $SETUP_FILE
    if( Test-Path $setup_base_path )
    {
        $generator_path = $setup_folder + "\" + $LICENSE_GENERATOR
        if( Test-Path $generator_path )
        {
            Copy-Item $setup_base_path $setup_file_path

            $file_data = ( Get-Content $setup_file_path ) -creplace $VERSION_TARGET, $app_version
            Set-Content $setup_file_path $file_data -Encoding UTF8

            # make setup file
            $gen_option = " " + $setup_file_path + " " + $setup_file_path
            if( $dbgprint ){ Write-Host "   (DBG)gen_option:"$gen_option }
            Start-Process -FilePath $generator_path -ArgumentList $gen_option -wait

            # correct setup file
            correctCompo $setup_file_path $dst_path $dbgprint
        }
        else
        {
            Write-Host "    No generator tool !!:"$generator_path
        }

        # correct setup.cmd file
        $setup_file_path = $setup_folder + "\" + $SETUP_CMD
        correctCompo $setup_file_path $dst_path $dbgprint
    }
    else
    {
        Write-Host "    No base setup file !!"
    }

    # correct file setup tools
    foreach( $setup_tool in $SETUP_TOOLS )
    {
        $part_of_tool_info = $SETUP_TOOL.Split("/",3);
        $src_path = $working_rootpath + "\" + $part_of_tool_info[0] + "\" + $part_of_tool_info[1]
        $src_path += "\bin\x64\Release\" + $part_of_tool_info[1] + "." + $part_of_tool_info[2]
        correctCompo $src_path $dst_path $dbgprint
    }

    if( $dbgprint ){ Write-Host "(DBG)makeSetupFile(OUT)" }
}

#
# Build - SampleApp for Launcher
#
function build_sampleApp
{
    if( $dbgprint ){ Write-Host "(DBG)build_sampleApp(IN)" }

    $target_solution = $working_rootpath + "\Launcher\" + $LAUNCHER_SAMPLE_APP + "\" + $LAUNCHER_SAMPLE_APP + ".sln"
    # check solution file
    if( Test-Path $target_solution )
    {
        # build option
        $bld_platform = "Any CPU"
        $bld_mode = "Release"

        # log file
        $log_file_name = $target_folder_rootpath_log+"\"+$LAUNCHER_SAMPLE_APP+"-"+$bld_mode+".log"

        # build option
        $bld_option = $target_solution+" /m /t:"+$BUILD_TYPE_MSBUILD+" /p:Configuration="+$bld_mode
        $bld_option += ' /p:Platform="'+$bld_platform+'" /flp:logfile='+$log_file_name

        # build
        do_build $BLD_COMMAND_MSBUILD $target_solution $bld_option $log_file_name $dbgprint
    }

    if( $dbgprint ){ Write-Host "(DBG)build_sampleApp(OUT)" }
}


#----------------------------------------
# Main script entry point
#----------------------------------------
#clear
Write-Host "`r`n<<<<< 20_build_compo >>>>>"
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
Write-Host "[STEP1] Set - build environment"
setBuildEnvironment $dbgprint

# Build for Launcher version
Write-Host "`r`n[STEP2] Build Components - Launcher"
folderCleanUp $target_folder_rootpath_launcher $dbgprint
build_components_launcher

# correct Components for Launcher version
Write-Host "`r`n[STEP3] Correct Components - Launcher"
correctForLauncher

# Delete binary files
deleteBinFolder $dbgprint

# Build for RCS version
Write-Host "`r`n[STEP4] Build Components - RCS"
build_components_rcs

# correct Components for RCS version
Write-Host "`r`n[STEP5] Correct Components - RCS"
folderCleanUp $target_folder_rootpath_compo $dbgprint
folderCleanUp $target_folder_rootpath_installer $dbgprint
correctForRCS

# make and correct Setup file
makeSetupFile

# Delete binary files
#deleteBinFolder $dbgprint

# Build - SampleApp for Launcher
Write-Host "`r`n[STEP6] Build - SampleApp"
build_sampleApp


#----- finished !! -----
Write-Host "`r`n<< FINISHED - 20_build_compo >>"
$end_time = Get-Date

Write-Host "  Operation start time:"$start_time
Write-Host "  Operation end time  :"$end_time
Write-Host "`r`n"

exit $ReturnCode
