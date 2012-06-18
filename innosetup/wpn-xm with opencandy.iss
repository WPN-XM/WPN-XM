//
//          _\|/_
//          (o o)
// +-----oOO-{_}-OOo------------------------------------------------------+
// |                                                                      |
// |  WPN-XM Server Stack - Inno Setup Script File                        |
// |  --------------------------------------------                        |
// |                                                                      |
// |  WPN-XM is a free and open-source web server solution stack for      |
// |  professional PHP development on the Windows platform.               |
// |                                                                      |
// |  The groundation of this stack consists of NGINX, MariaDb and PHP.   |
// |                                                                      |
// |  The stack contains several additional tools you might install:      |
// |                                                                      |
// |   - Server Control Panel for controlling server daemons,             |
// |   - WPN-XM Webinterface for administration of the stack,             |
// |   - Xdebug, Xhprof, webgrind for php debugging purposes,             |
// |   - phpMyAdmin for MySQL database administration,                    |
// |   - memcached and APC for caching purposes,                          |
// |   - junctions for creating symlinks.                                 |
// |                                                                      |
// |  Author:   Jens-Andre Koch <jakoch@web.de>                           |
// |  Website:  http://wpn-xm.org                                         |
// |  License:  GNU/GPLv2+                                                |
// |                                                                      |
// |  Note for developers                                                 |
// |  -------------------                                                 |
// |  A good resource for developing and understanding                    |
// |  Inno Setup Script files is the official "Inno Setup Help".          |
// |  Website:  http://jrsoftware.org/ishelp/index.php                    |
// |                                                                      |
// |  This version of the WPN-XM install wizard integrates OpenCandy.     |
// |  OpenCandy Integration Manual for InnoSetup:                         |
// |  http://sdk.opencandy.com/inno/index.html                            |
// |                                                                      |
// +---------------------------------------------------------------------<3
//

// toggle for enabling/disabling the debug mode
# define DEBUG "@DEBUG@"

// defines the root folder
#define SOURCE_ROOT AddBackslash(SourcePath);

// defines for the setup section
#define AppName "WPN-XM Server Stack"
// the -APPVERSION- token is replaced during the nant build process
#define AppVersion "@APPVERSION@"
#define AppPublisher "Jens-André Koch"
#define AppURL "http://wpn-xm.org/"
#define AppSupportURL "https://github.com/jakoch/WPN-XM/issues/new/"

// we need to include the Sherlock Software\InnoTools\Downloader
# include SOURCE_ROOT + "..\bin\InnoToolsDownloader\it_download.iss"

// [OpenCandy] Constants and File Setup
// product name
#define OC_STR_MY_PRODUCT_NAME 'Open Candy Sample'
// key and secret for this product
#define OC_STR_KEY '748ad6d80864338c9c03b664839d8161'
#define OC_STR_SECRET 'dfb3a60d6bfdb55c50e1ef53249f1198'
// Relative path to OCSetupHlp.dll; if not in the same folder as wpn-xm.iss file.
#define OC_OCSETUPHLP_FILE_PATH "..\bin\opencandy\OCSetupHlp.dll"

[Setup]
AppId={{8E0B8E63-FF85-4B78-9C7F-109F905E1D3B}}
AppName={#AppName}
AppVerName={#AppName} {#AppVersion}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
AppCopyright=© {#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppSupportURL}
AppUpdatesURL={#AppURL}
// default installation folder is "c:\server". but user might change this via dialog.
DefaultDirName={sd}\server
DefaultGroupName={#AppName}
OutputBaseFilename=WPNXM-{#AppVersion}-Setup
Compression=lzma2/ultra
InternalCompressLevel=max
SolidCompression=true
CreateAppDir=true
ShowLanguageDialog=no
BackColor=clBlack
; [OpenCandy]
	; OpenCandy requires PrivilegesRequired admin
; [/OpenCandy]
; Request admin privileges for Windows Vista, 7.
PrivilegesRequired=admin
; [OpenCandy]
	; You must display the OpenCandy EULA during installation
	; before the OpenCandy offer screen. We recommend appending
	; the OpenCandy EULA to your own license agreement.
; [/OpenCandy]
LicenseFile="..\bin\opencandy\OpenCandy EULA.txt"

// create a log file, see [code] procedure CurStepChanged
SetupLogging=yes
VersionInfoVersion={#AppVersion}
VersionInfoCompany={#AppPublisher}
VersionInfoDescription={#AppName} {#AppVersion}
VersionInfoTextVersion={#AppVersion}
VersionInfoCopyright=Copyright (C) 2011 - 2012 {#AppPublisher}, All Rights Reserved.
SetupIconFile={#SOURCE_ROOT}..\bin\icons\Setup.ico
WizardImageFile={#SOURCE_ROOT}..\bin\icons\innosetup-wizard-images\banner-left-164x314.bmp
WizardSmallImageFile={#SOURCE_ROOT}..\bin\icons\innosetup-wizard-images\icon-topright-55x55-stamp.bmp
; Tell Windows Explorer to reload the environment (because we are adding the PHP path to env var PATH)
ChangesEnvironment=yes

[Languages]
Name: en; MessagesFile: compiler:Default.isl
Name: de; MessagesFile: compiler:languages\German.isl

[Types]
Name: full; Description: Full installation
Name: serverstack; Description: Server Stack with Administration Tools
Name: debug; Description: Server Stack with Debugtools
Name: custom; Description: Custom installation; Flags: iscustom

[Components]
// Base Package Size is: PHP 15MB + MariaDB 180MB + Nginx 2 MB = 197 MB
Name: serverstack; Description: Base of the WPN-XM Server Stack (Nginx & PHP & MariaDb); ExtraDiskSpaceRequired: 197000000; Types: full serverstack debug custom; Flags: fixed
Name: webinterface; Description: WPN-XM - Webinterface for Serveradministration; ExtraDiskSpaceRequired: 500000; Types: full serverstack debug
Name: servercontrolpanel; Description: WPN-XM - Tray App for Serveradministration; ExtraDiskSpaceRequired: 500000; Types: full serverstack debug
Name: xdebug; Description: Xdebug - PHP Extension for Debugging; ExtraDiskSpaceRequired: 300000; Types: full debug
Name: apc; Description: APC - PHP Extension for Caching (Alternative PHP Cache); ExtraDiskSpaceRequired: 100000; Types: full debug
Name: webgrind; Description: Webgrind - Xdebug profiling web frontend; ExtraDiskSpaceRequired: 500000; Types: full debug
Name: xhprof; Description: XhProfiler - Hierarchical Profiler for PHP; ExtraDiskSpaceRequired: 1000000; Types: full debug
// memcached install means the daemon and the php extension
Name: memcached; Description: Memcached - distributed memory caching; ExtraDiskSpaceRequired: 400000; Types: full
Name: zeromq; Description: ZeroMQ - PHP Extension for concurrent socket magic; ExtraDiskSpaceRequired: 300000; Types: full
Name: phpmyadmin; Description: phpMyAdmin - MySQL database administration webinterface; ExtraDiskSpaceRequired: 3300000; Types: full
Name: adminer; Description: Adminer - Database management in single PHP file; ExtraDiskSpaceRequired: 355000; Types: full
Name: junction; Description: junction - Mircosoft tool for creating junctions (symlinks); ExtraDiskSpaceRequired: 157000; Types: full
Name: pear; Description: PEAR - PHP Extension and Application Repository; ExtraDiskSpaceRequired: 3510000; Types: full

[Files]
// opencandy
Source: "{#OC_OCSETUPHLP_FILE_PATH}"; Flags: dontcopy ignoreversion;
// tools
Source: ..\bin\UnxUtils\unzip.exe; DestDir: {tmp}; Flags: dontcopy
Source: ..\bin\HideConsole\RunHiddenConsole.exe; DestDir: {app}\bin\tools\
Source: ..\bin\killprocess\Process.exe; DestDir: {app}\bin\tools\
// psvince is install to app folder. it is needed during uninstallation, to to check if daemons are still running.
Source: ..\bin\psvince\psvince.dll; DestDir: {app}\bin\tools\
Source: ..\bin\create-mariadb-light-win32.bat; DestDir: {tmp}
// incorporate the whole "www" folder into the setup
Source: ..\www\*; DestDir: {app}\www; Flags: recursesubdirs; Excludes: *\nbproject*
// incorporate several startfiles
Source: ..\startfiles\administration.url; DestDir: {app}
Source: ..\startfiles\localhost.url; DestDir: {app}
Source: ..\startfiles\start-wpnxm.exe; DestDir: {app}
Source: ..\startfiles\stop-wpnxm.exe; DestDir: {app}
Source: ..\startfiles\status-wpnxm.bat; DestDir: {app}
Source: ..\startfiles\reset-db-pw.bat; DestDir: {app}
Source: ..\startfiles\go-pear.bat; DestDir: {app}\bin\php
// config files
Source: ..\configs\php.ini; DestDir: {app}\bin\php
Source: ..\configs\nginx.conf; DestDir: {app}\bin\nginx\conf
Source: ..\configs\vhosts.conf; DestDir: {app}\bin\nginx\conf
Source: ..\configs\my.ini; DestDir: {app}\bin\mariadb

[Icons]
Name: {group}\Start WPN-XM; Filename: {app}\start-wpnxm.exe
Name: {group}\Stop WPN-XM; Filename: {app}\stop-wpnxm.exe
Name: {group}\Status of WPN-XM; Filename: {app}\status-wpnxm.bat
Name: {group}\Localhost; Filename: {app}\localhost.url
Name: {group}\Administration; Filename: {app}\administration.url
Name: {group}\{cm:ProgramOnTheWeb,{#AppName}}; Filename: {#AppURL}
Name: {group}\{cm:ReportBug}; Filename: {#AppSupportURL}
Name: {group}\{cm:RemoveApp}; Filename: {uninstallexe}
Name: {userdesktop}\WPN-XM; Filename: {app}\start-wpnxm.exe; Tasks: desktopicon
Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\WPN-XM; Filename: {app}\start-wpnxm.exe; Tasks: quicklaunchicon

[Tasks]
Name: quicklaunchicon; Description: Create a &Quick Launch icon; GroupDescription: Additional icons:; Flags: unchecked
Name: desktopicon; Description: Create a &Desktop icon; GroupDescription: Additional icons:; Flags: unchecked

[Run]
// Automatically started...
Filename: {tmp}\create-mariadb-light-win32.bat; Parameters: {app}\bin\mariadb
//Filename: {app}\SETUP.EXE; Parameters: /x
// User selected... these files are shown for launch after everything is done
//Filename: {app}\README.TXT; Description: View the README file; Flags: postinstall shellexec skipifsilent
//Filename: {app}\SETUP.EXE; Description: Configure Server Stack; Flags: postinstall nowait skipifsilent unchecked

[INI]
;Filename: {app}\bin\php\php.ini, Section: PHP; Key: extenson; String: php_pdo_mysql.dll; Components: ;

[Registry]
; a registr change also needs the following directive: [SETUP] ChangesEnvironment=yes
; add PHP path to environment variable PATH
Root: HKCU; Subkey: "Environment"; ValueType:string; ValueName:"PATH"; ValueData:"{olddata};{app}\php\bin"; Flags: preservestringtype

[Messages]
// define wizard title and tray status msg
// both are normally defined in /bin/innosetup/default.isl
SetupAppTitle =Setup WPN-XM {#AppVersion}
SetupWindowTitle =Setup - {#AppName} {#AppVersion}

[CustomMessages]
de.WebsiteLink={#AppURL}
en.WebsiteLink={#AppURL}
de.ReportBug=Fehler melden
en.ReportBug=Report Bug
de.RemoveApp=WPN-XM Server Stack deinstallieren
en.RemoveApp=Uninstall WPN-XM Server Stack

[Dirs]
Name: {app}\www

[Code]
// open candy inno setup script
#include SOURCE_ROOT + "..\bin\opencandy\OCSetupHlp.iss"

// Constants and global variables
const
  // reassigning the preprocessor defined constant debug
  DEBUG = {#DEBUG};

  // Define download URLs for the software packages
  // Warning: Watch the protocol (Use http, not https!), if you add download links pointing to github.
  URL_nginx             = 'http://www.wpn-xm.org/mirror.php?s=nginx';
  URL_php               = 'http://www.wpn-xm.org/mirror.php?s=php';
  URL_mariadb           = 'http://www.wpn-xm.org/mirror.php?s=mariadb';
  URL_phpext_xdebug     = 'http://www.wpn-xm.org/mirror.php?s=phpext_xdebug';
  // pierre's APC is buggy, see https://bugs.php.net/bug.php?id=61984
  //URL_phpext_apc        = 'http://downloads.php.net/pierre/php_apc-3.1.10-5.4-vc9-x86.zip';
  URL_phpext_apc        = 'http://www.wpn-xm.org/mirror.php?s=phpext_apc';
  URL_webgrind          = 'http://www.wpn-xm.org/mirror.php?s=webgrind';
  // Leave the original url of xhprof in here ! we are fetching from paul reinheimers fork !
  //URL_xhprof          = 'http://nodeload.github.com/facebook/xhprof/zipball/master';
  URL_xhprof            = 'http://www.wpn-xm.org/mirror.php?s=xhprof';
  URL_memcached         = 'http://www.wpn-xm.org/mirror.php?s=memcached';
  URL_phpext_memcached  = 'http://www.wpn-xm.org/mirror.php?s=phpext_memcache';
  URL_phpext_zeromq     = 'http://www.wpn-xm.org/mirror.php?s=phpext_zeromq';
  URL_phpmyadmin        = 'http://www.wpn-xm.org/mirror.php?s=phpmyadmin';
  URL_adminer           = 'http://www.wpn-xm.org/mirror.php?s=adminer';
  URL_junction          = 'http://www.wpn-xm.org/mirror.php?s=junction';
  URL_pear              = 'http://www.wpn-xm.org/mirror.php?s=pear';
  URL_wpnxmscp          = 'http://www.wpn-xm.org/mirror.php?s=wpnxmscp';

  // Define file names for the downloads
  Filename_nginx            = 'nginx.zip';
  Filename_php              = 'php.zip';
  Filename_mariadb          = 'mariadb.zip';
  Filename_phpext_xdebug    = 'xdebug.dll';
  Filename_phpext_apc       = 'phpext-apc.zip';
  Filename_webgrind         = 'webgrind.zip';
  Filename_xhprof           = 'xhprof.zip';
  Filename_memcached        = 'memcached.zip';
  Filename_phpext_memcache  = 'phpext-memcache.zip'; // memcache without D
  Filename_phpext_zeromq    = 'phpext-zmq.zip';
  Filename_phpmyadmin       = 'phpmyadmin.zip';
  Filename_adminer          = 'adminer.php';
  Filename_junction         = 'junction.zip';
  Filename_pear             = 'go-pear.phar';
  Filename_wpnxmscp         = 'wpnxmscp.zip';

var
  unzipTool   : String;   // path+filename of unzip helper for exec
  returnCode  : Integer;  // errorcode
  targetPath  : String;   // if debug true will download to app/downloads, else temp dir
  appPath     : String;   // application path (= the installaton folder)
  InstallPage               : TWizardPage;
  percentagePerComponent    : Integer;

procedure UrlLabelClick(Sender: TObject);
var
  errorCode : integer;
begin
  ShellExec('','http://wpn-xm.org/','','', SW_SHOWNORMAL, ewNoWait, errorCode);
end;

{
  Custom wpInstalling Page with two progress bars.

  The first progress bar shows the total progress.
    (1 of 10 zips to unzip = 10 %)
  The second progress bar shows the current operation progress
    (unzipping component 2: 25% of 100%)

  Page is put into the install page loop via
  CurPageChanged(CurPageID) -> CurPageID=wpInstalling then CustomWpInstallingPage;
}
procedure CustomWpInstallingPage;
var
  { Total Progress Bar }
  TotalProgressBar                : TNewProgressBar;
  TotalProgressLabel              : TLabel;
  TotalProgressStaticText         : TNewStaticText;

  { Current Component Progress Bar }
  CurrentComponentProgressBar     : TNewProgressBar;
  CurrentComponentLabel           : TLabel;
  CurrentComponentStaticText      : TNewStaticText;

begin
  // CustomPage is shown after the wpReady page
  InstallPage := CreateCustomPage(wpReady,'Installation', 'Description');

  { Total Progress Bar }

  TotalProgressStaticText := TNewStaticText.Create(InstallPage);
  TotalProgressStaticText.Top := 16;
  TotalProgressStaticText.Caption := 'Total Progress';
  TotalProgressStaticText.AutoSize := True;
  TotalProgressStaticText.Parent := InstallPage.Surface;

  TotalProgressBar := TNewProgressBar.Create(InstallPage);
  TotalProgressBar.Name := 'TotalProgressBar'; // needed for FindComponent()
  TotalProgressBar.Left := 24;
  TotalProgressBar.Top := 40;
  TotalProgressBar.Width := 366;
  TotalProgressBar.Height := 24;
  TotalProgressBar.Min := 0
  TotalProgressBar.Max := 100
  TotalProgressBar.Parent := InstallPage.Surface;

  TotalProgressLabel := TLabel.Create(InstallPage);
  TotalProgressLabel.Name := 'TotalProgressLabel'; // needed for FindComponent()
  TotalProgressLabel.Top := TotalProgressStaticText.Top;
  TotalProgressLabel.Left := TotalProgressBar.Width;
  TotalProgressLabel.Caption := '0 %';
  TotalProgressLabel.Alignment := taRightJustify;
  TotalProgressLabel.Font.Style := [fsBold];
  TotalProgressLabel.Parent := InstallPage.Surface;

  { Current Component Progress Bar }

  CurrentComponentStaticText := TNewStaticText.Create(InstallPage);
  CurrentComponentStaticText.Top := 80;
  CurrentComponentStaticText.Caption := 'Extracting Component';
  CurrentComponentStaticText.AutoSize := True;
  CurrentComponentStaticText.Parent := InstallPage.Surface;

  CurrentComponentProgressBar := TNewProgressBar.Create(InstallPage);
  CurrentComponentProgressBar.Name := 'CurrentComponentProgressBar'; // needed for FindComponent()
  CurrentComponentProgressBar.Left := 24;
  CurrentComponentProgressBar.Top := 104;
  CurrentComponentProgressBar.Width := 366;
  CurrentComponentProgressBar.Height := 24;
  CurrentComponentProgressBar.Min := 0
  CurrentComponentProgressBar.Max := 100
  // Marquee displays some activity on the progressbar (pseudo progress)
  CurrentComponentProgressBar.Style := npbstMarquee;
  CurrentComponentProgressBar.Parent := InstallPage.Surface;

  CurrentComponentLabel := TLabel.Create(InstallPage);
  CurrentComponentLabel.Name := 'CurrentComponentLabel'; // needed for FindComponent()
  CurrentComponentLabel.Top := CurrentComponentStaticText.Top;
  CurrentComponentLabel.Width := 20;
  CurrentComponentLabel.Left := CurrentComponentProgressBar.Width;
  CurrentComponentLabel.Alignment := taRightJustify;
  CurrentComponentLabel.Caption := '';
  CurrentComponentLabel.Font.Style := [fsBold];
  CurrentComponentLabel.Parent := InstallPage.Surface;

  { Render Page }

  InstallPage.Surface.Show;       // show the new page
  InstallPage.Surface.Update;     // activate showing updates on this page
end;

procedure InitializeWizard();
var
  UrlLabel      : TNewStaticText;
  DebugLabel    : TNewStaticText;
  VersionLabel  : TLabel;
  VersionLabel2 : TLabel;
  CancelBtn     : TButton;
begin
  //change background colors of wizard pages and panels
  WizardForm.Mainpanel.Color:=$ECECEC;
  WizardForm.TasksList.Color:=$ECECEC;
  WizardForm.ReadyMemo.Color:=$ECECEC;
  WizardForm.WelcomePage.Color:=$ECECEC;
  WizardForm.FinishedPage.Color:=$ECECEC;
  WizardForm.WizardSmallBitmapImage.BackColor:=$ECECEC;

  //  Setup InnoTools Download Helper

// [OpenCandy] init, check for offers by asynchronous call
  OpenCandyAsyncInit('{#OC_STR_MY_PRODUCT_NAME}', '{#OC_STR_KEY}', '{#OC_STR_SECRET}', OCtszInstallerLanguage, {#OC_INIT_MODE_NORMAL});

  // Initialize InnoTools Download Helper
  ITD_Init;
  // Turns on detailed error message popups for debugging the download process
  if (DEBUG = true) then ITD_SetOption('Debug_Messages', '1');
  // Change from a simple overall progress bar to the detailed download view
  ITD_SetOption('UI_DetailedMode', '1');
  // when download fails, do not allow continuing with the installation
  ITD_SetOption('UI_AllowContinue', '0');
  // Start the download after the "Ready to install" screen is shown
  ITD_DownloadAfter(wpReady);
  // reset files to download
  ITD_ClearFiles();

  // Display the Version Number as overlay on the WizardImageFile (banner-left)
  // Label for the WelcomePage
  VersionLabel            := TLabel.Create(WizardForm);
  VersionLabel.Top        := 43;
  VersionLabel.Left       := 129;
  VersionLabel.Caption    := ExpandConstant('{#AppVersion}');
  VersionLabel.Font.Name  := 'Tahoma';
  VersionLabel.Font.Size  := 7;
  VersionLabel.Font.Style := [fsBold];
  VersionLabel.Font.Color := $343434;
  VersionLabel.Parent     := WizardForm.WelcomePage;
  // Label for the Finished Page
  // ( @todo because i don't know how to attach one object to both wizard pages )
  VersionLabel2            := TLabel.Create(WizardForm);
  VersionLabel2.Top        := 43;
  VersionLabel2.Left       := 129;
  VersionLabel2.Caption    := ExpandConstant('{#AppVersion}');
  VersionLabel2.Font.Name  := 'Tahoma';
  VersionLabel2.Font.Size  := 7;
  VersionLabel2.Font.Style := [fsBold];
  VersionLabel2.Font.Color := $343434;
  VersionLabel2.Parent     := WizardForm.FinishedPage;

  // Display website link in the bottom left corner of the install wizard
  CancelBtn           := WizardForm.CancelButton;
  UrlLabel            := TNewStaticText.Create(WizardForm);
  UrlLabel.Top        := CancelBtn.Top + (CancelBtn.Height div 2) - (UrlLabel.Height div 2);
  UrlLabel.Left       := WizardForm.ClientWidth - CancelBtn.Left - CancelBtn.Width;
  UrlLabel.Caption    := ExpandConstant('{cm:WebsiteLink}');
  UrlLabel.Font.Style := UrlLabel.Font.Style + [fsUnderline];
  UrlLabel.Cursor     := crHand;
  UrlLabel.Font.Color := clHighlight;
  UrlLabel.OnClick    := @UrlLabelClick;
  UrlLabel.Parent     := WizardForm;

  // Show that Debug Mode is active
  if DEBUG = true then
  begin
    DebugLabel            := TNewStaticText.Create(WizardForm);
    DebugLabel.Top        := UrlLabel.Top;
    DebugLabel.Left       := UrlLabel.Left + UrlLabel.Width + 12;
    DebugLabel.Caption    := ExpandConstant('DEBUG ON');
    DebugLabel.Font.Style := [fsBold];
    DebugLabel.Parent     := WizardForm;
  end;
end;

function NextButtonClick(CurPage: Integer): Boolean;
(*
	Called when the user clicks the Next button.
    If you return True, the wizard will move to the next page.
	If you return False, it will remain on the current page (specified by CurPageID).
*)
begin
  if CurPage = wpSelectComponents then
  begin

    // Define "targetPath" for the downloads. It depends on the debug mode.

    if DEBUG = false then
    begin
      // In non debug mode the temp path is used for downloading.
      // The downloaded components are deleted after installation.
      targetPath := ExpandConstant('{tmp}\');
    end else
    begin
      // In debug mode the "c:\wpnxm-downloads" path is used.
      // The downloaded components are not deleted after installation.
      // If you reinstall, the components are taken from there (no download).
      targetPath := ExpandConstant('c:\wpnxm-downloads\');

      // create folder, if it doesn't exist
      if not DirExists(ExpandConstant(targetPath)) then ForceDirectories(ExpandConstant(targetPath));
    end;

    {
      Leave this!   - It's for determining the download file sizes manually
      There is a strange bug, when trying to get the filesize from googlecode.
      So webgrind has a size of 0. Thats way "unknown" is shown as total progress.

      ITD_GetFileSize(URL_xhprof, size);
      MsgBox(intToStr(size), mbError, MB_OK);
    }

    // Add Files to Download Handler

    if IsComponentSelected('serverstack') then
    begin
      ITD_AddFile(URL_nginx,   ExpandConstant(targetPath + Filename_nginx));
      ITD_AddFile(URL_php,     ExpandConstant(targetPath + Filename_php));
      ITD_AddFile(URL_mariadb, ExpandConstant(targetPath + Filename_mariadb));
    end;

    if IsComponentSelected('servercontrolpanel') then
    begin
      ITD_AddFile(URL_wpnxmscp, ExpandConstant(targetPath + Filename_wpnxmscp));
    end;

    if IsComponentSelected('xdebug')    then ITD_AddFile(URL_phpext_xdebug, ExpandConstant(targetPath + Filename_phpext_xdebug));
    if IsComponentSelected('apc')       then ITD_AddFile(URL_phpext_apc,    ExpandConstant(targetPath + Filename_phpext_apc));
    if IsComponentSelected('webgrind')  then ITD_AddFileSize(URL_webgrind,  ExpandConstant(targetPath + Filename_webgrind), 648000);
    if IsComponentSelected('xhprof')    then ITD_AddFile(URL_xhprof,        ExpandConstant(targetPath + Filename_xhprof));

    if IsComponentSelected('memcached') then
    begin
        ITD_AddFile(URL_memcached,        ExpandConstant(targetPath + Filename_memcached));
        ITD_AddFile(URL_phpext_memcached, ExpandConstant(targetPath + Filename_phpext_memcache));
    end;

    if IsComponentSelected('zeromq')     then ITD_AddFile(URL_phpext_zeromq, ExpandConstant(targetPath + Filename_phpext_zeromq));
    if IsComponentSelected('phpmyadmin') then ITD_AddFile(URL_phpmyadmin,    ExpandConstant(targetPath + Filename_phpmyadmin));
    if IsComponentSelected('adminer')    then ITD_AddFile(URL_adminer,       ExpandConstant(targetPath + Filename_adminer));
    if IsComponentSelected('junction')   then ITD_AddFile(URL_junction,      ExpandConstant(targetPath + Filename_junction));
    if IsComponentSelected('pear')       then ITD_AddFile(URL_pear,          ExpandConstant(targetPath + Filename_pear));

    // if DEBUG On and already downloaded, skip downloading files, by resetting files
    if (DEBUG = true) then MsgBox('Debug On. Skipping all downloads, because file exists: ' + ExpandConstant(targetPath + 'nginx.zip'), mbInformation, MB_OK);

    if (DEBUG = true) and (FileExists(ExpandConstant(targetPath + 'nginx.zip'))) then ITD_ClearFiles();

  end; // of wpSelectComponents

  Result := True;
end;

procedure DoUnzip(source: String; targetdir: String);
begin
    // source contains tmp constant, so resolve it to path name
    source := ExpandConstant(source);

    unzipTool := ExpandConstant('{tmp}\unzip.exe');

    if not FileExists(unzipTool)
    then MsgBox('UnzipTool not found: ' + unzipTool, mbError, MB_OK)
    else if not FileExists(source)
    then MsgBox('File was not found while trying to unzip: ' + source, mbError, MB_OK)
    else begin
         if Exec(unzipTool, '-o -qq "' + source + '" -d "' + targetdir + '"',
                 '', SW_HIDE, ewWaitUntilTerminated, ReturnCode) = false
         then begin
             MsgBox('Unzip failed:' + source, mbError, MB_OK)
         end;
    end;
end;

procedure UpdateTotalProgressBar();
{
  This procedure is called, when installing a component is finished.
  It updates the TotalProgessBar and the Label in the InstallationScreen with the new percentage.
}
var
    newTotalPercentage : integer;
    TotalProgressBar   : TNewProgressBar;
    TotalProgressLabel : TLabel;
begin
    // Fetch ProgressBar
    TotalProgressBar := TNewProgressBar(InstallPage.FindComponent('TotalProgressBar'));
    // calculate new total percentage
    newTotalPercentage := TotalProgressBar.Position + percentagePerComponent;
    // set to progress bar
    TotalProgressBar.Position := newTotalPercentage;

    // Fetch Label
    TotalProgressLabel := TLabel(InstallPage.FindComponent('TotalProgressLabel'));
    // set to label
    TotalProgressLabel.Caption := intToStr(newTotalPercentage) + ' %';
end;

{
  This procedure is called, when installing a new component starts.
  It updates the CurrentComponentLabel with the name of the component.
}
procedure UpdateCurrentComponentName(component: String);
var
    CurrentComponentLabel : TLabel;
begin
    // fetch label
    CurrentComponentLabel := TLabel(InstallPage.FindComponent('CurrentComponentLabel'));
    // set to label
    CurrentComponentLabel.Caption := component;
end;

procedure UnzipFiles();
var
  selectedComponents     : String;
  intTotalComponents     : Integer;
  i                      : Integer;
begin
  selectedComponents := WizardSelectedComponents(false);

  // count components (get only the selected ones from the total number of components to unzip)
  for i := 0 to WizardForm.ComponentsList.Items.Count - 1 do
    if WizardForm.ComponentsList.Checked[i]=true then
    intTotalComponents:=intTotalComponents+1;

  if (DEBUG = true) then MsgBox('The following components are selected:' + selectedComponents + '. Counter: ' + IntToStr(intTotalComponents), mbInformation, MB_OK);

  // serverstack base are 3 components in 1 so we have to add 2 to the counter
  intTotalComponents:=intTotalComponents+2;

  {
    Calculate the percentage per component: (100% / components) = ppc

    When processing a component is finished, this value is added to the progress bar.
    When all values are added (UpdateTotalProgressBar()), we will reach 100 % in total on the progress bar. (ppc * components) = 100%
  }
  percentagePerComponent := (100 div intTotalComponents);

  if (DEBUG = true) then MsgBox('Each processed component will add ' + intToStr(percentagePerComponent) + ' % to the progress bar.', mbInformation, MB_OK);

  // fetch the unzip command from the compressed setup
  ExtractTemporaryFile('unzip.exe');

  if not DirExists(ExpandConstant('{app}\bin')) then ForceDirectories(ExpandConstant('{app}\bin'));
  if not DirExists(ExpandConstant('{app}\www')) then ForceDirectories(ExpandConstant('{app}\www'));

  // Update Progress Bars

  // always unzip the serverstack base (3 components)

  UpdateCurrentComponentName('Nginx');
    DoUnzip(targetPath + Filename_nginx, ExpandConstant('{app}\bin')); // no subfolder, because nginx brings own dir
      UpdateTotalProgressBar();

  UpdateCurrentComponentName('PHP');
    DoUnzip(targetPath + Filename_php, ExpandConstant('{app}\bin\php'));
      UpdateTotalProgressBar();

  UpdateCurrentComponentName('MariaDB');
    DoUnzip(targetPath + Filename_mariadb, ExpandConstant('{app}\bin')); // no subfolder, brings own dir
      UpdateTotalProgressBar();

  // unzip selected components

  if Pos('servercontrolpanel', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('WPN-XM Server Control Panel');
      DoUnzip(ExpandConstant(targetPath + Filename_wpnxmscp), ExpandConstant('{app}')); // no subfolder, top level
        UpdateTotalProgressBar();
  end;

  // xdebug is not a zipped, its just a dll file, so copy it to the target path
  if Pos('xdebug', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Xdebug');
      FileCopy(ExpandConstant(targetPath + Filename_phpext_xdebug), ExpandConstant('{app}\bin\php\ext\php_xdebug.dll'), false);
        UpdateTotalProgressBar();
  end;

  if Pos('apc', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('APC');
      // archive contains ts/nts folders, unzip to temp dir, copy file from there
      DoUnzip(targetPath + Filename_phpext_apc, targetPath + '\apc');
      FileCopy(ExpandConstant(targetPath + '\apc\nts\php_apc.dll'), ExpandConstant('{app}\bin\php\ext\php_apc.dll'), false);
        UpdateTotalProgressBar();
  end;

  if Pos('webgrind', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Webgrind');
      DoUnzip(targetPath + Filename_webgrind, ExpandConstant('{app}\www')); // no subfolder, brings own dir
        UpdateTotalProgressBar();
  end;

  if Pos('xhprof', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('XHProf');
      DoUnzip(targetPath + Filename_xhprof, ExpandConstant('{app}\www')); // no subfolder, brings own dir
        UpdateTotalProgressBar;
  end;

  if Pos('memcached', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Memcached');
      DoUnzip(targetPath + Filename_memcached, ExpandConstant('{app}\bin')); // no subfolder, brings own dir
      DoUnzip(targetPath + Filename_phpext_memcache, ExpandConstant('{app}\bin\php\ext'));
        UpdateTotalProgressBar();
  end;

  if Pos('zeromq', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('ZeroMQ');
      // a) archive contains ts/nts folders, unzip to temp dir, copy file from there
      DoUnzip(targetPath + Filename_phpext_zeromq, targetPath + '\zmq');
      FileCopy(ExpandConstant(targetPath + '\zmq\nts\php_zmq.dll'), ExpandConstant('{app}\bin\php\ext\php_zmq.dll'), false);
      // b) archive contains lib_zmq.dll which must be copied to php
      FileCopy(ExpandConstant(targetPath + '\zmq\libzmq.dll'), ExpandConstant('{app}\bin\php\libzmq.dll'), false);
        UpdateTotalProgressBar();
  end;

  if Pos('phpmyadmin', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('phpMyAdmin');
      DoUnzip(targetPath + Filename_phpmyadmin, ExpandConstant('{app}\www')); // no subfolder, brings own dir
        UpdateTotalProgressBar;
  end;

  // adminer is not a zipped, its just a php file, so copy it to the target path
  if Pos('adminer', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Adminer');
      CreateDir(ExpandConstant('{app}\www\adminer\'));
      FileCopy(ExpandConstant(targetPath + Filename_adminer), ExpandConstant('{app}\www\adminer\' + Filename_adminer), false);
        UpdateTotalProgressBar();
  end;

  if Pos('junction', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Junction');
      DoUnzip(targetPath + Filename_junction, ExpandConstant('{app}\bin\tools'));
        UpdateTotalProgressBar();
  end;

  // pear is not a zipped, its just a php phar package, so copy it to the php path
  if Pos('pear', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('PEAR');
      CreateDir(ExpandConstant('{app}\bin\php\PEAR\'));
      FileCopy(ExpandConstant(targetPath + Filename_pear), ExpandConstant('{app}\bin\php\PEAR\' + Filename_pear), false);
        UpdateTotalProgressBar();
  end;

end;

procedure MoveFiles();
var
  selectedComponents: String;
begin
  selectedComponents := WizardSelectedComponents(false);

  // set application path as global variable
  appPath := ExpandConstant('{app}');

  // nginx - rename directory
  Exec('cmd.exe', '/c "move ' + appPath + '\bin\nginx-* ' + appPath + '\bin\nginx"',
  '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);

  // MariaDB - rename directory
  Exec('cmd.exe', '/c "move ' + appPath + '\bin\mariadb-*  ' + appPath + '\bin\mariadb"',
   '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);

  // MariaDB - install with user ROOT and password TOOP
  Exec('cmd.exe', '/c ' + appPath + '\bin\mariadb\mysql_install_db.exe --default-user=root --password=toop --datadir="' + appPath + '\bin\mariadb\data"',
   '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);

  if Pos('xhprof', selectedComponents) > 0 then
  begin
    // deactivated, because we are fetching from preinheimer's fork, see below
    // xhprof - rename "facebook-xhprof-gitref" directory
    //Exec('cmd.exe', '/c "move ' + appPath + '\www\facebook-xhprof* ' + appPath + '\www\xhprof"',
    //'', SW_SHOW, ewWaitUntilTerminated, ReturnCode);

    // xhprof - rename "preinheimer-xhprof-gitref" directory
    Exec('cmd.exe', '/c "move ' + appPath + '\www\preinheimer-xhprof* ' + appPath + '\www\xhprof"',
    '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);
  end;

  if Pos('memcached', selectedComponents) > 0 then
  begin
      // rename the existing directory
      Exec('cmd.exe', '/c "move ' + appPath + '\bin\memcached-x86 ' + appPath + '\bin\memcached"',
      '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);
  end;

  if Pos('phpmyadmin', selectedComponents) > 0 then
  begin
     // phpmyadmin - rename "phpMyAdmin-3.4.6-english" directory
    Exec('cmd.exe', '/c "move ' + appPath + '\www\phpMyAdmin-*  ' + appPath + '\www\phpmyadmin"',
    '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);
  end;

end;

procedure DoPreInstall();
{
   DoPreInstall will be called after the user clicks Next on the wpReady page,
   but before Inno installs any of the [Files] and other standard script items.

   Its triggered by CurStep == ssInstall in procedure CurStepChanged().

   Workflow: wpReady to Install -> Click Next (Triggers ssInstall) -> wpInstalling
}
begin
  UnzipFiles();
  MoveFiles();
end;

procedure Configure();
var
  selectedComponents: String;
  appPathWithSlashes : String;
  php_ini_file : String;
  mariadb_ini_file : String;
begin
  selectedComponents := WizardSelectedComponents(false);

  // set application path as global variable
  appPath := ExpandConstant('{app}');

  { Explanation: StringChange(S,FromStr,ToStr): Change all occurances in S of FromStr to ToStr.
    StringChange works on the string!! StringChange does not return S!
  }
  appPathWithSlashes := appPath;
  StringChange (appPathWithSlashes, '\', '/');

  // config files

  php_ini_file := appPath + '\bin\php\php.ini';
  mariadb_ini_file := appPath + '\bin\mariadb\my.ini';

  // modifications to the config files

  // MariaDb

  // http://dev.mysql.com/doc/refman/5.5/en/server-options.html#option_mysqld_log-error
  // waring: mysqld will not start if backslashes (\) are used. fwd slashes (/) needed!
  SetIniString('mysqld', 'log-error',        appPathWithSlashes + '/logs/mariadb_error.log',  mariadb_ini_file );

  // PHP
  SetIniString('PHP', 'error_log',           appPath + '\logs\php_error.log',       php_ini_file );
  SetIniString('PHP', 'doc_root',            appPath + '\www',                      php_ini_file );
  SetIniString('PHP', 'include_path',        '.;' + appPath + '\bin\php\pear',      php_ini_file );
  SetIniString('PHP', 'upload_tmp_dir',      appPath + '\temp',                     php_ini_file );
  SetIniString('PHP', 'upload_max_filesize', '8M',                                  php_ini_file );
  SetIniString('PHP', 'session.save_path',   appPath + '\temp',                     php_ini_file );

  // Xdebug
  if Pos('xdebug', selectedComponents) > 0 then
  begin
      // add loading of xdebug.dll to php.ini
      if not IniKeyExists('Zend', 'zend_extension', php_ini_file) then
      begin
          SetIniString('Zend', 'zend_extension', appPath + '\bin\php\ext\php_xdebug.dll', php_ini_file );
      end;

      // activate remote debugging
      SetIniString('Xdebug', 'xdebug.remote_enable',  'on',        php_ini_file );
      SetIniString('Xdebug', 'xdebug.remote_handler', 'dbgp',      php_ini_file );
      SetIniString('Xdebug', 'xdebug.remote_host',    'localhost', php_ini_file );
      SetIniString('Xdebug', 'xdebug.remote_port',    '9000',      php_ini_file );
  end;

  if Pos('zeromq', selectedComponents) > 0 then
  begin
      // php.ini entry for loading the the extension
      //SetIniString('PHP', 'extension', 'php_zmq.dll', php_ini_file ); // disabled in v0.3.x: MODULE API=20090625 != PHP API 20100525
  end;

  if Pos('memcached', selectedComponents) > 0 then
  begin
      // php.ini entry for loading the the extension
      //SetIniString('PHP', 'extension', 'php_memcache.dll', php_ini_file ); // disabled in v0.3.0: MODULE API=20090625 != PHP API 20100525
  end;

  if Pos('apc', selectedComponents) > 0 then
  begin
      // php.ini entry for loading the the extension
      //SetIniString('PHP', 'extension', 'php_apc.dll', php_ini_file ); // APC buggy: disabled for 0.3.0 release
  end;
end;

{
  DoPostInstall will be called after Inno has completed installing all of
  the [Files], [Registry] entries, and so forth, and also after all the
  non-postinstall [Run] entries, but before the wpInfoAfter or wpFinished pages.

  Its triggerd by CurStep == ssPostInstall. see procedure CurStepChanged().

  wpInstalling Install finshed -> ssPostInstall
}
procedure DoPostInstall();
begin
  Configure()
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  logfilepathname : String;
  logfilename : String;
  newfilepathname : String;
begin
  if CurStep = ssInstall then
  begin
    DoPreInstall();
  end;

  if CurStep = ssPostInstall then
  begin
    DoPostInstall();
  end;

 // when the setup wizward is finished
 if CurStep = ssDone then
   begin
     // copy logfile from tmp dir to the application dir
     logfilepathname := ExpandConstant('{log}');
     logfilename := ExtractFileName(logfilepathname);
     newfilepathname := ExpandConstant('{app}\') + logfilename;
     filecopy(logfilepathname, newfilepathname, false);
   end;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID=wpInstalling then CustomWpInstallingPage();
  // [OpenCandy]
  OpenCandyCurPageChanged(CurPageID);
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := false; // Don't skip pages by default
  // [OpenCandy]
  if OpenCandyShouldSkipPage(PageID) then
    Result := true;
end;

function BackButtonClick(CurPageID: Integer): Boolean;
begin
  Result := true; // Allow action by default
  // [OpenCandy]
  OpenCandyBackButtonClick(CurPageID);

{
  Uninstaller

  a) Display Dialogbox
     Warning the user about the deletion of the WPN-XM folder.
     This is ensures no user projects get lost (/www/projects).

  b) Check for running daemon processes before uninstallation.
     Provide Button to shut them down.
     Shutdown is needed, in order to delete them.
}

// boolean function for calling IsModuleLoaded on psvince.dll
function IsModuleLoaded(modulename: String ):  Boolean;
external 'IsModuleLoaded@{app}\bin\tools\psvince.dll stdcall uninstallonly';

function ProcessesRunningWhenUninstall(): Boolean;
var
  index : Integer;
  processes: Array [1..4] of String;
begin
  // fill processes array with process executables to look for
  processes[1] := 'nginx.exe';
  processes[2] := 'memcached.exe';
  processes[3] := 'php-cgi.exe';
  processes[4] := 'mysqld.exe';

  // method return value defaults to false, meaning that no processes is running
  Result := false;

  // iterate processes
  for index := 1 to 4 do
  begin
    // and check if process is running (using external call to psvince.dll)
    if ( IsModuleLoaded( processes[index] ) = true ) then
    begin
     // MsgBox( processes[index] + ' is running, please close it and run again uninstall.', mbError, MB_OK );
     Result := true;
    end;

  end;
end;

function InitializeUninstall(): Boolean;
var
  ResultCode: Integer;
  ButtonPressed: Integer;
begin
  ButtonPressed := IDRETRY;

  // Check if daemons are running or if the user has pressed the cancel button.
  // We need to perform a check for running daemon processes,
  // because files of running processes can not be deleted while running.
  while ProcessesRunningWhenUninstall and ( ButtonPressed <> IDCANCEL ) do
  begin
    ButtonPressed := MsgBox('Some server processes are still running.'#13#10 +
                            'Click Retry to shut them down and continue uninstallation, or click Cancel to quit the uninstaller.',
                            mbError, MB_RETRYCANCEL );

    if( ButtonPressed = IDRETRY ) then
    begin
      // "Yes/Retry" clicked, now shutdown the processes
      if Exec('cmd.exe', '/c ' + ExpandConstant('{app}\stop-wpnxm.exe'), '', SW_HIDE,
         ewWaitUntilTerminated, ResultCode) then
      begin
        Result := ResultCode > 0;
      end;
    end;

    // "Cancel" clicked, quits the un-installer
    if( ButtonPressed = IDCANCEL ) then
    begin
      Result := false;
      Exit;
    end;

  end;

  // unload the dll, otherwise the psvince.dll is not deleted, because in use
  UnloadDLL(ExpandConstant('{app}\bin\tools\psvince.dll'));

  Result := true;
end;

{
  Watch it! Recursion!
}
procedure DeleteWPNXM(ADirName: string);
var
  FindRec: TFindRec;
begin
  MsgBox('Deleting WPNXM (' + ADirName + '\*.*)', mbError, MB_OK);

  if FindFirst( ADirName + '\*.*', FindRec) then begin
    try
      repeat
        // delete folder
        if FindRec.Attributes and FILE_ATTRIBUTE_DIRECTORY <> 0 then begin
          if (FindRec.Name <> '.') and (FindRec.Name <> '..') then begin
            DeleteWPNXM(ADirName + '\' + FindRec.Name);
            RemoveDir(ADirName + '\' + FindRec.Name);
          end;
        end;
        // delete file
        DeleteFile(ADirName + '\' + FindRec.Name);
      until not FindNext(FindRec);
    finally
      FindClose(FindRec);
    end;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then begin
    if MsgBox('***WARNING***'#13#10#13#10 +
              'The WPN-XM installation folder is [ '+ ExpandConstant('{app}') +' ].'#13#10 +
              'You are about to delete this folder and all its subfolders,'#13#10 +
              'including [ '+ ExpandConstant('{app}') +'\www ], which may contain your projects.'#13#10#13#10 +
              'This is your last chance to do a backup of your files.'#13#10#13#10 +
              'Do you want to proceed?'#13#10, mbConfirmation,
        MB_YESNO) = IDYES
    then begin
      DeleteWPNXM(ExpandConstant('{app}'));
    end;
  end;
end;
end;

procedure DeinitializeSetup();
begin
  // [OpenCandy]
  OpenCandyDeinitializeSetup();
end;