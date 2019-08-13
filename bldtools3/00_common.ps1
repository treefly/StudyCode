#
# Name       : 00_common.ps1
# Description: PowerShell script designed to build the Wearable Viewer Remote Communication System.
#              common functions
#

#
# Parameter
#   -dbgprint   : print some debug messages
#
#-----*-----*----- Parameters -----*-----*-----
### Server information
#(ToDo)

### Folder (header)
# Header for Remote Communication Tools
$WVRCS_FOLDER = "DERCS"
# Result
$WVRCS_RELEASE_FOLDER = "wvrcs_"
# Binary folder - Result
$WVRCS_COMPO_FOLDER = "wvrcs.Compo_"
# Installer folder - Result
$WVRCS_INSTALLER_FOLDER = "wvrcs.Installer_"
# Symbol(pdb) folder - Result
$WVRCS_PDB_FOLDER = "wvrcs.Pdb_"

# Header for Launcher
$LAUNCHER_FOLDER = "AppLauncher"
# Launcher folder - Result
$LAUNCHER_RELEASE_FOLDER = "AppLauncher_"
# Binary folder(Launcher) - Result
$LAUNCHER_COMPO_FOLDER = "AppLauncher.Compo_"
# Installer folder(Launcher) - Result
$LAUNCHER_INSTALLER_FOLDER = "AppLauncher.Installer_"
# Symbol(pdb) folder(Launcher) - Result
$LAUNCHER_PDB_FOLDER = "AppLauncher.Pdb_"

# Source archive
$SOURCE_TREE_FOLDER = "wvrcs.Src_"
$SOURCE_TREE_TARGET = "BackEnd\*", "FrontEnd\*", "Common\*", "extdll\*", "wvrcs.sln", "wvrcs-installer.sln"
# Installer folder - Result
$INSTALL_FOLDER_FRONT_END = "DERCS Front-end"
$INSTALL_FOLDER_BACK_END = "DERCS Back-end"
# Launcher folder
$LAUNCHER_SAMPLE_APP = "SampleApp"
$LAUNCHER_ADD_MODULE_STD = "Installer\Installer.vdproj", "Zephyranthes.sln"
$LAUNCHER_ADD_SAMPLE = $LAUNCHER_SAMPLE_APP + "\*"
$LAUNCHER_ADD_MODULE = $LAUNCHER_ADD_MODULE_STD + $LAUNCHER_ADD_SAMPLE

### Version file
$VERSION_FILE = "version.txt"
$VERSION_TARGET_FILE = "AssemblyInfo"
$VERSION_TARGET = "3.0.0.0"

### Setup (include license) File
$SETUP_WORK_FOLDER ="setup"
$SETUP_BASE = "setup_base.xml"
$SETUP_FILE = "setup.xml"
$SETUP_CMD = "setup.cmd"
$SETUP_TOOLS = "FrontEnd/TosRCInitialize/exe", "Common/TosRCLoggerlib/dll"
$LICENSE_GENERATOR = "TosRCHashGenerator.exe"

### Module type
$EDIT_PROJECT = "FrontEnd\TosRCHome\TosRCHome.csproj"
#add zhangHaiLun
#$EDIT_PROJECTS = "FrontEnd\TosRCHome\TosRCHome.csproj", "FrontEnd\TosRCCamera\TosRCCamera.csproj", "FrontEnd\TosRCJpgViewer\TosRCJpgViewer.csproj", "FrontEnd\TosRCMp4Player\TosRCMp4Player.csproj", "FrontEnd\TosRCPdfViewer\TosRCPdfViewer.csproj", "FrontEnd\TosRCRemoteComm\TosRCRemoteComm.csproj"
$EDIT_PROJECTS = "FrontEnd\TosRCHome\TosRCHome.csproj", "FrontEnd\TosRCCamera\TosRCCamera.csproj", "FrontEnd\TosRCJpgViewer\TosRCJpgViewer.csproj", "FrontEnd\TosRCMp4Player\TosRCMp4Player.csproj", "FrontEnd\TosRCPdfViewer\TosRCPdfViewer.csproj", "FrontEnd\TosRCRemoteComm\TosRCRemoteComm.csproj" , "FrontEnd\TMMCTransferStatusService\TMMCTransferStatusService.csproj", "FrontEnd\TosRCTask\TosRCTask.csproj"
$RELEASE_COMPILE_SYMBOL_RCS = "TRACE"
$RELEASE_COMPILE_SYMBOL_LAUNCHER = ";FW_LAUNCHER"

### Build environment
# Root of output folder
$OUTPUT_FOLDER = "output"
# Script folder
$SCRIPT_FOLDER = "\bldtools3"
# path to build tools
$PATH_DEVTOOL_MSBUILD = "C:\Program Files (x86)\MSBuild\14.0\Bin"
$PATH_DEVTOOL_DEVENV = "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE"
# Target components
$COMPONENTS_LIST_FRONT_END = "FrontEnd\TosRCCamera", "FrontEnd\TosRCHome",
        "FrontEnd\TosRCJpgViewer", "FrontEnd\TosRCMp4Player", "FrontEnd\TosRCPdfViewer",
        "FrontEnd\TosRCQuickSet", "FrontEnd\TosRCRemoteComm", "FrontEnd\TosRCSettings",
        "FrontEnd\TosRCStatus", "FrontEnd\TosRCInitialize","FrontEnd\TosRCTask"
        "FrontEnd\Common\TosRCCameraCtrl", "FrontEnd\Common\TosRCExtendControlsLib",
        "FrontEnd\Common\TosRCGlassLib", "FrontEnd\Common\TosRCMessage",
        "FrontEnd\Common\TosRCProcComLib", "FrontEnd\Common\TosRCSettingLib",
        "FrontEnd\Common\TosRCVerticalListLib", "FrontEnd\Common\TosRCVoiceCommandLib", "FrontEnd\Common\TosRCTMMCAppAuth", "FrontEnd\Common\TosRCHttpRequestLib","FrontEnd\Common\TosRCTaskFlowLib"
$COMPONENTS_LIST_BACK_END = "BackEnd\TosRCSupport"
$COMPONENTS_LIST_COMMON = "Common\TosRCLoggerlib", "Common\TosRCXmlLib"
$COMPONENTS_LIST = $COMPONENTS_LIST_FRONT_END + $COMPONENTS_LIST_BACK_END + $COMPONENTS_LIST_COMMON
$COMPONENTS_LIST_CLANG = "FrontEnd\Vuzix\USBCViewer\USBCViewer", "FrontEnd\Vuzix\USBCViewerFlip\USBCViewerFlip"
# Target installer
$COMPONENTS_LIST_INSTALLER_RCS_FRONT = "FrontEnd\TosRCSetupFrontEnd"
$COMPONENTS_LIST_INSTALLER_RCS_BACK = "BackEnd\TosRCSetupBackEnd"
$COMPONENTS_LIST_INSTALLER_LAUNCHER = "Launcher\Installer"
$COMPONENTS_LIST_INSTALL = $COMPONENTS_LIST_INSTALLER_RCS_FRONT, $COMPONENTS_LIST_INSTALLER_RCS_BACK, $COMPONENTS_LIST_INSTALLER_LAUNCHER

### CodeSign
$CODESIGN_FOLDER_PATH = "ForInstaller"
$CS_FILELIST_RCS = "VisionDESuite_Compo_List.txt"
$CS_FILELIST_LAUNCHER = "AppLauncher_Compo_List.txt"
$CS_FILELIST_INSTALLER = "Installer_List.txt"


#-----*-----*----- Error Code -----*-----*-----
$ERR_CODE = Data {
    ConvertFrom-StringData @'
    Success = 0
    NoValidInfo = 1
    NoTargetFile = 2
    NoInformationFile = 3
    NoSolutionFile = 4
    NoProjectFile = 5
    BuildError = 6
    InvalidCompoPath = 7
    NoValidCompo = 8
    NoTools = 9
    CodeSigningError =10
'@
}


#-----*-----*----- Functions -----*-----*-----

#
# Print error message and exit
#
function printErrorMassageAndExit( $RetCode, $ErrMsg )
{
    Write-Host "`r`n<<<<<<<<<< !! ERROR !! >>>>>>>>>>`r`n[ "$ErrMsg" ( ErrCode="$RetCode" ) ]`r`n"
    exit $RetCode
}

#
# Initial Process
#
function initialProcess( $bDbgprint )
{
    # set initial value
    $Script:ReturnCode = $ERR_CODE.Success
    $Script:working_rootpath = $ScriptDir.Replace($SCRIPT_FOLDER, "")

    # get version information (set to $app_version)
    getVersionInfo $bDbgprint
    if( $bDbgprint ){ Write-Host "  (DBG)app_version:"$app_version }

    # Set local environment
    $Script:target_folder_rootpath_log = $working_rootpath + "\" + $OUTPUT_FOLDER + "\Log_" + $app_version
    $Script:target_folder_rootpath_release = $working_rootpath + "\" + $OUTPUT_FOLDER + "\v" + $app_version

    $Script:target_folder_rootpath_wvrcs = $working_rootpath + "\" + $OUTPUT_FOLDER + "\" + $WVRCS_FOLDER
    $Script:target_folder_rootpath_source = $target_folder_rootpath_wvrcs + "\" + $SOURCE_TREE_FOLDER + $app_version
    $Script:target_folder_rootpath_compo = $target_folder_rootpath_wvrcs + "\" +$WVRCS_COMPO_FOLDER + $app_version
    $Script:target_folder_rootpath_installer = $target_folder_rootpath_wvrcs + "\" + $WVRCS_INSTALLER_FOLDER + $app_version

    $Script:target_folder_rootpath_launcher = $working_rootpath + "\" + $OUTPUT_FOLDER + "\" + $LAUNCHER_FOLDER
    $Script:target_folder_rootpath_launcher_compo = $target_folder_rootpath_launcher + "\" + $LAUNCHER_COMPO_FOLDER + $app_version
    $Script:target_folder_rootpath_launcher_release = $target_folder_rootpath_launcher + "\" + $LAUNCHER_RELEASE_FOLDER + $app_version
    $Script:target_folder_rootpath_launcher_installer = $target_folder_rootpath_launcher + "\" + $LAUNCHER_INSTALLER_FOLDER + $app_version

    $Script:target_folder_rootpath_cswork = $working_rootpath + "\" + $OUTPUT_FOLDER + "\" + $CODESIGN_FOLDER_PATH
    $Script:target_folder_rootpath_rcs_cswork = $target_folder_rootpath_cswork + "\" + $WVRCS_FOLDER
    $Script:target_folder_rootpath_launcher_cswork = $target_folder_rootpath_cswork + "\" + $LAUNCHER_FOLDER

    if( $bDbgprint ){
        Write-Host "  target_folder_rootpath_log                :"$target_folder_rootpath_log
        Write-Host "  target_folder_rootpath_release            :"$target_folder_rootpath_release
        Write-Host ""
        Write-Host "  target_folder_rootpath_wvrcs              :"$target_folder_rootpath_wvrcs
        Write-Host "  target_folder_rootpath_source             :"$target_folder_rootpath_source
        Write-Host "  target_folder_rootpath_compo              :"$target_folder_rootpath_compo
        Write-Host "  target_folder_rootpath_installer          :"$target_folder_rootpath_installer
        Write-Host ""
        Write-Host "  target_folder_rootpath_launcher           :"$target_folder_rootpath_launcher
        Write-Host "  target_folder_rootpath_launcher_compo     :"$target_folder_rootpath_launcher_compo
        Write-Host "  target_folder_rootpath_launcher_release   :"$target_folder_rootpath_launcher_release
        Write-Host "  target_folder_rootpath_launcher_installer :"$target_folder_rootpath_launcher_installer
        Write-Host ""
        Write-Host "  target_folder_rootpath_cswork             :"$target_folder_rootpath_cswork
        Write-Host "  target_folder_rootpath_rcs_cswork         :"$target_folder_rootpath_rcs_cswork
        Write-Host "  target_folder_rootpath_launcher_cswork    :"$target_folder_rootpath_launcher_cswork
    }

    # print build environment
    Write-Host ""
    Write-Host "  Build information"
    Write-Host "    Version         : "$app_version
    Write-Host "    Working rootpath: "$working_rootpath
    Write-Host "    ScriptDir       : "$ScriptDir
    Write-Host ""
}

#
# get version
#
function getVersionInfo( $bDbgprint )
{
    if( $bDbgprint ){ Write-Host "(DBG)getVersionInfo(IN)" }

    if( Test-Path $VERSION_FILE )
    {
        $version_information = Get-Content $VERSION_FILE
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
            }
        }
        $Script:app_version = $app_version + "." + $revision_no
    }
    else
    {
        # No build information file
        $Script:app_version = $VERSION_TARGET
    }

    if( $bDbgprint ){ Write-Host "(DBG)getVersionInfo(OUT)`r`n" }
}

#
# delete target folder if exist
#
function deleteTargetFolder( $target_folder, $bDbgprint )
{
    if( $bDbgprint ){
        Write-Host "(DBG)deleteTargetFolder(IN)"
        Write-Host "  (DBG)target_folder:"$target_folder
    }

    if( Test-Path $target_folder )
    {
        # delete target folder
        Remove-Item $target_folder -Recurse -Force
        if( $bDbgprint ){ Write-Host "  (DBG) deleted" }
    }

    if( $bDbgprint ){ Write-Host "(DBG)deleteTargetFolder(OUT)`r`n" }
}

#
# set environment valiables
#
function setBuildEnvironment( $bDbgprint )
{
    if( $bDbgprint ){ Write-Host "(DBG)setBuildEnvironment(IN)" }

    Write-Host "  (Original path)"
    Write-Host "   "$env:Path"`r`n"

    $PATH_DEVTOOL = $PATH_DEVTOOL_MSBUILD+";"+$PATH_DEVTOOL_DEVENV
    $part_of_path = $env:Path.Split(";",2);
    if( !($part_of_path[0] -eq $PATH_DEVTOOL_MSBUILD) )
    {
        $DEV_PATH = $PATH_DEVTOOL+";"+$env:Path
        $env:Path = $DEV_PATH
    }

    Write-Host "  (New path)"
    Write-Host "   "$env:Path"`r`n"

    if( $bDbgprint ){ Write-Host "(DBG)setBuildEnvironment(OUT)" }
}

#
# folder clean-up
#
function folderCleanUp( $target_folder, $bDbgprint )
{
    if( $bDbgprint ){ Write-Host "(DBG)folderCleanUp(IN)" }

    deleteTargetFolder $target_folder $bDbgprint
    New-Item $target_folder -ItemType Directory

    if( $bDbgprint ){ Write-Host "(DBG)folderCleanUp(OUT)" }
}

#
# Set Module type
#
function setModuleType( $mod_type, $bDbgprint )
{
    if( $bDbgprint ){ Write-Host "(DBG)setModuleType(IN)" }

    foreach( $pj in $EDIT_PROJECTS )
    {
	    $target_file = $working_rootpath + "\" + $pj

	    if( Test-Path $target_file )
	    {
	        if( $bDbgprint )
	        {
	            Write-Host "  (DBG)mod_type   :"$mod_type
	            Write-Host "  (DBG)target_file:"$target_file
	        }

	        if( $mod_type -eq "LAUNCHER" )
	        {
	            # for Launcher version
	            $target_constants = $RELEASE_COMPILE_SYMBOL_RCS
	            $new_constants = $RELEASE_COMPILE_SYMBOL_RCS+$RELEASE_COMPILE_SYMBOL_LAUNCHER
	        }
	        else
	        {
	            # for RCS version
	            $target_constants = $RELEASE_COMPILE_SYMBOL_LAUNCHER
	            $new_constants = ""
	        }
	        $file_data = ( Get-Content $target_file ) -creplace $target_constants, $new_constants
	        Set-Content $target_file $file_data -Encoding UTF8
	    }
	    else
	    {
	        # No build information file
	        printErrorMassageAndExit $ERR_CODE.NoProjectFile "Target project file does not found !!"
	    }
    }

    if( $bDbgprint ){ Write-Host "(DBG)setModuleType(OUT)" }
}

#
# make log folder
#
function mklogfolder( $log_folder_path )
{
    # make log folder
    if( !(Test-Path $log_folder_path) )
    {
        New-Item $log_folder_path -ItemType Directory
    }
}

#
# Build
#
function do_build( $build_cmd, $target_solution, $bld_option, $log_file_name, $bDbgprint )
{
    if( $bDbgprint ){ Write-Host "(DBG)do_build(IN)" }

    # Build information
    Write-Host "   Target Solution:"$target_solution
    Write-Host "     Log file name:"$log_file_name
    if( $bDbgprint ){ Write-Host "          Build option:"$bld_option }
    Write-Host "   Please wait a minutes ..."

    # build
    do_extcmd $build_cmd $bld_option $bDbgprint

    if( $bDbgprint ){ Write-Host "(DBG)do_build(OUT)" }
}

#
# Execute extend command
#
function do_extcmd( $ext_cmd, $ext_option, $bDbgprint )
{
    if( $bDbgprint ){ Write-Host "(DBG)do_extcmd(IN)" }

    # do extend command
    $ext_start_time = Get-Date -Format "HH:mm:ss"
    $ext_process = Start-Process -FilePath $ext_cmd -ArgumentList $ext_option -PassThru
    Wait-Process -Id ( $ext_process.Id )
    $result = $ext_process.ExitCode
    $ext_end_time = Get-Date -Format "HH:mm:ss"

    if( $bDbgprint ){ Write-Host "(DBG)do_extcmd(OUT)" }
}

#
# correct component
#
function correctCompo( $src_path, $dst_path, $bDbgprint )
{
    if( $bDbgprint ){ Write-Host "(DBG)correctCompo(IN)" }
    
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

    if( $bDbgprint ){ Write-Host "(DBG)correctCompo(OUT)" }
}

#
# clean-up
#
function deleteBinFolder( $bDbgprint )
{
    if( $bDbgprint ){ Write-Host "(DBG)deleteBinFolder(IN)" }

    $target_root = $working_rootpath + "\"
    Get-ChildItem $target_root -Recurse -include "bin" | Remove-Item -Recurse -Force
    Get-ChildItem $target_root -Recurse -include "obj" | Remove-Item -Recurse -Force

    if( $bDbgprint ){ Write-Host "(DBG)deleteBinFolder(OUT)" }
}

#
# move component  复制移文件到新目录下，强制删除旧路径文件
#
function moveCompo( $src_path, $dst_path, $bDbgprint )
{
    if( $bDbgprint ){ Write-Host "(DBG)moveCompo(IN)" }

    correctCompo $src_path $dst_path $bDbgprint
    Remove-Item $src_path -Force

    if( $bDbgprint ){ Write-Host "(DBG)moveCompo(OUT)" }
}
