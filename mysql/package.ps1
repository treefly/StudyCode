
#----------------------------------------
# Main script entry point
#----------------------------------------
#clear
$start_time = Get-Date

#脚本所在文件夹路径
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
