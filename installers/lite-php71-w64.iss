;
;          _\|/_
;          (o o)
; +-----oOO-{_}-OOo------------------------------------------------------+
; |                                                                      |
; |  WPN-XM Server Stack - Inno Setup Script File                        |
; |  --------------------------------------------                        |
; |                                                                      |
; |  WPN-XM is an open-source web server solution stack for              |
; |  professional PHP development on the Windows platform.               |
; |                                                                      |
; |  Author:   Jens-Andre Koch <jakoch@web.de>                           |
; |  Website:  http://wpn-xm.org/                                        |
; |  License:  MIT                                                       |
; |                                                                      |
; |  For the full copyright and license information, please view         |
; |  the LICENSE file that was distributed with this source code.        |
; |                                                                      |
; |  Note for developers                                                 |
; |  -------------------                                                 |
; |  A good resource for developing and understanding                    |
; |  Inno Setup Script files is the official "Inno Setup Help".          |
; |  Website:  http://jrsoftware.org/ishelp/index.php                    |
; |                                                                      |
; +---------------------------------------------------------------------<3

; Uncomment the line below to be able to compile the script locally from the IDE.
;#define COMPILE_FROM_IDE

; debug mode toggle
#define DEBUG                "false"

; the -STACK_VERSION- token is replaced during the build process
#ifdef COMPILE_FROM_IDE
#define APP_VERSION          "LocalSnapshot"
#else
#define APP_VERSION          "@STACK_VERSION@"
#endif

#define APP_NAME             "WPN-XM Server Stack"
#define APP_PUBLISHER        "Jens-Andre Koch"
#define APP_URL              "http://wpn-xm.org/"
#define APP_SUPPORT_URL      "https://github.com/WPN-XM/WPN-XM/issues/new/"
#define COPYRIGHT_YEAR        GetDateTimeString('yyyy', '', '');
#define CODESIGN_INSTALLER   "false"

#define INSTALLER_TYPE       "Lite"
#define PHP_VERSION          "php71"
#define BITSIZE              "w64"

#define SOURCE_ROOT          AddBackslash(SourcePath);
#define INSTALLER_FOLDER     LowerCase(INSTALLER_TYPE);
#define DOWNLOAD_FOLDER      INSTALLER_FOLDER +'-'+ APP_VERSION + '-' + PHP_VERSION + '-' + BITSIZE


[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{8E0B8E63-FF85-4B78-9C7F-109F905E1D3B}}
AppName={#APP_NAME}
AppVerName={#APP_NAME} {#APP_VERSION}
AppVersion={#APP_VERSION}
AppPublisher={#APP_PUBLISHER}
AppCopyright=© {#APP_PUBLISHER}
AppPublisherURL={#APP_URL}
AppSupportURL={#APP_SUPPORT_URL}
AppUpdatesURL={#APP_URL}
; default installation folder is "c:\server". users might change this via dialog.
DefaultDirName={sd}\server
DefaultGroupName={#APP_NAME}
OutputBaseFilename=WPNXM-{#APP_VERSION}-{#INSTALLER_TYPE}-Setup-{#PHP_VERSION}-{#BITSIZE}
Compression=lzma2/ultra
LZMAUseSeparateProcess=yes
LZMANumBlockThreads=2
InternalCompressLevel=max
SolidCompression=true
CloseApplications=no
; disable wizard pages: Languages, Ready, Select Start Menu Folder
ShowLanguageDialog=no
DisableReadyPage=yes
DisableProgramGroupPage=yes
ShowComponentSizes=no
BackColor=clBlack
PrivilegesRequired=none
; create a log file, see [code] procedure CurStepChanged
SetupLogging=yes
#ifndef COMPILE_FROM_IDE
VersionInfoVersion={#APP_VERSION}
#endif
VersionInfoCompany={#APP_PUBLISHER}
VersionInfoDescription={#APP_NAME} {#APP_VERSION}
VersionInfoTextVersion={#APP_VERSION}
VersionInfoCopyright=Copyright (C) 2011 - {#COPYRIGHT_YEAR} {#APP_PUBLISHER}, All Rights Reserved.
SetupIconFile={#SOURCE_ROOT}..\bin\icons\Setup.ico
WizardImageFile={#SOURCE_ROOT}..\bin\icons\innosetup-wizard-images\banner-left-164x314-lite.bmp
WizardSmallImageFile={#SOURCE_ROOT}..\bin\icons\innosetup-wizard-images\icon-topright-55x55-stamp.bmp
; Tell Windows Explorer to reload the environment, because we modify the environment variable PATH
ChangesEnvironment=yes
; Portable Mode
; a) do no create registry keys for uninstallation
CreateUninstallRegKey=not IsTaskSelected('portablemode')
; b) do not include uninstaller
Uninstallable=not IsTaskSelected('portablemode')
; code-sign the installer
#if "True" == CODESIGN_INSTALLER
SignTool=__SIGNTOOL__
SignedUnInstaller=yes
#endif

; include the sections [Languages], [Messages], [CustomMessages]
#include "includes\languages.iss"

[Types]
Name: full; Description: Full installation
Name: custom; Description: Custom installation; Flags: iscustom

[Components]
; The base component "serverstack" consists of PHP + MariaDB + Nginx. These three components are always installed.
Name: serverstack; Description: Base of the WPN-XM Server Stack (Nginx & PHP & MariaDb); ExtraDiskSpaceRequired: 192430000; Types: full custom; Flags: fixed
Name: adminer; Description: Adminer - Database management in single PHP file; ExtraDiskSpaceRequired: 355000; Types: full
Name: conemu; Description: Conemu - Advanced console emulator with multiple tabs; ExtraDiskSpaceRequired: 8700000; Types: full
Name: benchmark; Description: WPN-XM Benchmark Tools; ExtraDiskSpaceRequired: 100000; Types: full
Name: composer; Description: Composer - Dependency Manager for PHP; ExtraDiskSpaceRequired: 486000; Types: full
Name: pickle; Description: Pickle - PHP Extension Installer; ExtraDiskSpaceRequired: 486000; Types: full
Name: servercontrolpanel; Description: WPN-XM - Tray App for Serveradministration; ExtraDiskSpaceRequired: 500000; Types: full
Name: xdebug; Description: Xdebug - Debugger and Profiler Tool for PHP; ExtraDiskSpaceRequired: 300000; Types: full
Name: openssl; Description: OpenSSL - transport protocol security layer (SSL/TLS); ExtraDiskSpaceRequired: 1000000; Types: full

[Files]
; incorporate all files of the download folder for this installation wizard
Source: ..\downloads\{#DOWNLOAD_FOLDER}\*; Flags: nocompression dontcopy
; tools:
Source: ..\bin\7zip\x64\7za.exe; DestDir: {tmp}; Flags: dontcopy
Source: ..\bin\7zip\x64\*; DestDir: {app}\bin\tools\
Source: ..\bin\7zip\License.txt; DestDir: {app}\docs\licenses\; DestName: 7zip_license.txt;
Source: ..\bin\backup\*; DestDir: {app}\bin\backup\
Source: ..\bin\HideConsole\RunHiddenConsole.exe; DestDir: {app}\bin\tools\
Source: ..\bin\hosts\hosts.exe; DestDir: {app}\bin\tools\
Source: ..\bin\php-cgi-spawner\php-cgi-spawner.exe; DestDir: {app}\bin\php-cgi-spawner\
; psvince is installed to the app folder, because it's needed during uninstallation, to check if daemons are still running.
Source: ..\bin\psvince\psvince.dll; DestDir: {app}\bin\tools\
; copy "www" folder into the setup, except examples folder
Source: ..\www\*; DestDir: {app}\www; Flags: recursesubdirs; Excludes: \tools\examples,.git*;
; ship documentation, changelog and license information
Source: ..\docs\*; DestDir: {app}\docs;
; incorporate several startfiles and shortcut commands
Source: ..\startfiles\backup.bat; DestDir: {app}
Source: ..\startfiles\composer.bat; DestDir: {app}\bin\composer; Components: composer
Source: ..\startfiles\console.bat; DestDir: {app}; Components: conemu
Source: ..\startfiles\pickle.bat; DestDir: {app}\bin\pickle; Components: pickle
Source: ..\startfiles\generate-certificate.bat; DestDir: {app}\bin\openssl; Components: openssl
Source: ..\startfiles\update-phars.bat; DestDir: {app}\bin\php\
Source: ..\startfiles\reset-db-pw.bat; DestDir: {app}
Source: ..\startfiles\restart.bat; DestDir: {app}
Source: ..\startfiles\start-scp-server.bat; DestDir: {app}
Source: ..\startfiles\run.bat; DestDir: {app}
Source: ..\startfiles\status.bat; DestDir: {app}
Source: ..\startfiles\stop.bat; DestDir: {app}


; backup config files, when upgrading
Source: {app}\bin\php\php.ini; DestDir: {app}\bin\php; DestName: "php.ini.old"; Flags: external skipifsourcedoesntexist
Source: {app}\bin\nginx\conf\nginx.conf; DestDir: {app}\bin\nginx\conf; DestName: "nginx.conf.old"; Flags: external skipifsourcedoesntexist
Source: {app}\bin\mariadb\my.ini; DestDir: {app}\bin\mariadb; DestName: "my.ini.old"; Flags: external skipifsourcedoesntexist
Source: {app}\bin\backup\backup.txt; DestDir: {app}\bin\backup; DestName: "backup.txt.old"; Flags: external skipifsourcedoesntexist

; config files
Source: ..\software\php\config\{#PHP_VERSION}\php.ini;     DestDir: {app}\bin\php
Source: ..\software\nginx\config\nginx.conf;               DestDir: {app}\bin\nginx\conf
Source: ..\software\nginx\config\conf\sites-disabled\*;    DestDir: {app}\bin\nginx\conf\sites-disabled
Source: ..\software\nginx\html\errorpages\*;               DestDir: {app}\bin\nginx\html\errorpages
Source: ..\software\mariadb\config\my.ini;                 DestDir: {app}\bin\mariadb
Source: ..\software\openssl\config\openssl.cfg;            DestDir: {app}\bin\openssl;     Components: openssl
Source: ..\software\openssl\cert-bundle\ca-bundle.crt;     DestDir: {app}\bin\openssl;     Components: openssl
Source: ..\software\conemu\config\*;                       DestDir: {app}\bin\conemu;      Components: conemu
Source: ..\software\conemu\images\*;                       DestDir: {app}\bin\conemu;      Components: conemu

; Visual C++ Redistributable 2015 is needed by PHP VC14 builds
; The file is always included, but installed only if needed, see conditional install check in the run section.
Source: ..\bin\vcredist\vcredist_x64_2015.exe; DestDir: {tmp}; Flags: deleteafterinstall

[Icons]
Name: {group}\Server Control Panel; Filename: {app}\wpn-xm.exe; Tasks: add_startmenu
Name: {group}\Start WPN-XM; Filename: {app}\run.bat; Tasks: add_startmenu
Name: {group}\Stop WPN-XM; Filename: {app}\stop.bat; Tasks: add_startmenu
Name: {group}\Status of WPN-XM; Filename: {app}\status.bat; Tasks: add_startmenu
Name: {group}\Localhost; Filename: {app}\localhost.url; Tasks: add_startmenu
Name: {group}\Administration; Filename: {app}\administration.url; Tasks: add_startmenu
Name: {group}\{cm:ProgramOnTheWeb,{#APP_NAME}}; Filename: {#APP_URL}; Flags: preventpinning excludefromshowinnewinstall; Tasks: add_startmenu
Name: {group}\{cm:ReportBug}; Filename: {#APP_SUPPORT_URL}; Flags: preventpinning excludefromshowinnewinstall; Tasks: add_startmenu
Name: {group}\{cm:RemoveApp}; Filename: {uninstallexe}; Flags: preventpinning excludefromshowinnewinstall; Tasks: add_startmenu
Name: {userdesktop}\WPN-XM ServerControlPanel; Filename: {app}\wpn-xm.exe; Tasks: add_desktopicon
Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\WPN-XM; Filename: {app}\wpn-xm.exe; Tasks: add_quicklaunchicon
Name: {userdesktop}\WPN-XM Start; Filename: {app}\run.bat; Tasks: add_startstop_desktopicons
Name: {userdesktop}\WPN-XM Stop; Filename: {app}\stop.bat; Tasks: add_startstop_desktopicons

[Tasks]
Name: portablemode; Description: Portable Mode; Flags: unchecked
Name: add_startmenu; Description: Create Startmenu entries
Name: add_quicklaunchicon; Description: Create a &Quick Launch icon for the Server Control Panel; GroupDescription: Additional Icons:; Components: servercontrolpanel
Name: add_desktopicon; Description: Create a &Desktop icon for the Server Control Panel; GroupDescription: Additional Icons:; Components: servercontrolpanel
Name: add_startstop_desktopicons; Description: Create &Desktop icons for starting and stopping; GroupDescription: Additional Icons:; Flags: unchecked

[Run]
; Automatically started...
; VCRedist Conditional Installation Check
Filename: "{tmp}\vcredist_x64_2015.exe"; Parameters: "/quiet /norestart"; Check: VCRedist_x64_2015_NeedsInstall; Flags: nowait
; User selected Postinstallation runs...
Filename: {app}\wpn-xm.exe; Description: Start Server Control Panel; Flags: postinstall nowait skipifsilent unchecked; Components: servercontrolpanel

[Registry]
; A registry change needs the following directive: [SETUP] ChangesEnvironment=yes
; The registry is not modified, when in portable mode.
Root: HKCU; Subkey: "Environment"; ValueType:string; ValueName:"PATH"; ValueData:"{olddata};{app}\bin\php"; Flags: preservestringtype; Check: NeedsAddPathCurrentUser(ExpandConstant('{app}\bin\php')); Tasks: not portablemode;
Root: HKCU; Subkey: "Environment"; ValueType:string; ValueName:"PATH"; ValueData:"{olddata};{app}\bin\mariadb\bin"; Flags: preservestringtype; Check: NeedsAddPathCurrentUser(ExpandConstant('{app}\bin\mariadb\bin')); Tasks: not portablemode;
; when installation "Pickle", add "/bin/pickle" to PATH
Root: HKCU; Subkey: "Environment"; ValueType:string; ValueName:"PATH"; ValueData:"{olddata};{app}\bin\pickle"; Flags: preservestringtype; Check: NeedsAddPathCurrentUser(ExpandConstant('{app}\bin\pickle')); Tasks: not portablemode; Components: pickle;

[Dirs]
Name: {app}\bin\backup
Name: {app}\bin\nginx\conf\sites-enabled
Name: {app}\logs
Name: {app}\temp

[Code]
// include Unzip() helper
#include "includes\unzip.iss"

// include helper for VCRedist Conditional Installation Check
#include "includes\vcredist.iss"

// modification and path lookup helper for env PATH 
#include "includes\envpath.iss"

var
  // the controls move on resize
  WebsiteButton : TButton;
  HelpButton    : TButton;
  DebugLabel    : TNewStaticText;

const
  // reassign preprocessor constant debug
  DEBUG = {#DEBUG};

  {
    Define download file names
  }

  // Define file names for the downloads
  Filename_adminer           = 'adminer.php';
  Filename_composer          = 'composer.phar';
  Filename_conemu            = 'conemu.7z';
  Filename_mariadb           = 'mariadb.zip';
  Filename_nginx             = 'nginx.zip';
  Filename_openssl           = 'openssl.zip';
  Filename_php               = 'php.zip';
  Filename_phpext_xdebug     = 'phpext_xdebug.zip';
  Filename_pickle            = 'pickle.phar';
  Filename_wpnxm_benchmark   = 'wpnxm-benchmark.zip';
  Filename_wpnxm_scp         = 'wpnxmscp.zip';

var
  targetPath  : String;   // init in prepareUnzip() - if debug true will download to app/downloads, else temp dir
  appDir      : String;   // init in prepareUnzip() - installation folder of the application
  hideConsole : String;   // init in prepareUnzip() - shortcut to {tmp}\runHiddenConsole.exe
  InstallPage                   : TWizardPage;
  intTotalComponents            : Integer;
  intInstalledComponentsCounter : Integer;

// Runs an external command via RunHiddenConsole
function ExecHidden(Command: String): Integer;
var
  ErrorCode: Integer;
begin
  if Exec(hideConsole, ExpandConstant(Command), '', SW_SHOW, ewWaitUntilTerminated, ErrorCode) then
  begin
    Result := ErrorCode;
  end
  else
  begin
    Log('[Error] ExecHidden failed executing the following command: [' + ExpandConstant(Command) + ']');
    Result := ErrorCode;
  end;
end;

function ReplaceStringInFile(const SearchString: String; const ReplaceString: String; const FileName: String): boolean;
var
  MyFile : TStrings;
  MyText : string;
begin
  MyFile := TStringList.Create;

  try
    result := true;

    try
      MyFile.LoadFromFile(FileName);
      MyText := MyFile.Text;

      if StringChangeEx(MyText, SearchString, ReplaceString, True) > 0 then // save only, if text was changed
      begin;
        MyFile.Text := MyText;
        MyFile.SaveToFile(FileName);
      end;
    except
      result := false;
    end;
  finally
    MyFile.Free;
  end;
end;

procedure OpenBrowser(Url: string);
var
  ErrorCode: Integer;
begin
  ShellExec('open', Url, '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

procedure HelpButtonClick(Sender: TObject);
begin
  // example URL: http://wpn-xm.org/help.php?section=installation-wizard&type=webinstaller&page=1&version=0.6.0&language=de
  OpenBrowser('{#APP_URL}help.php'
    + '?section=installation-wizard'
    + '&type=' + Lowercase(ExpandConstant('{#INSTALLER_TYPE}'))
    + '&page=' + IntToStr(WizardForm.CurPageID)
    + '&version=' + ExpandConstant('{#APP_VERSION}')
    + '&language=' + ExpandConstant('{language}'));
end;

procedure WebsiteButtonClick(Sender: TObject);
begin
  OpenBrowser('{#APP_URL}');
end;

{
  Custom wpInstalling Page with two progress bars.

  The first progress bar shows the total progress.
    (1 of 10 zips to unzip = 10 %)
  The second progress bar shows the current operation progress.
    (unzipping component 2: 25% of 100%)

  The Page is put into the install page loop via
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
  // Custom InstallPage is shown after the wpReady page
  InstallPage := CreateCustomPage(wpReady, 'Installation', 'Description');

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
  // The inital state of Min and Position is "-1". Position is set to "0", after Max has been
  // calculated, based on the number of selected components (see GetTotalNumberOfComponents()).
  TotalProgressBar.Min := -1
  TotalProgressBar.Position := -1
  TotalProgressBar.Parent := InstallPage.Surface;

  TotalProgressLabel := TLabel.Create(InstallPage);
  TotalProgressLabel.Name := 'TotalProgressLabel'; // needed for FindComponent()
  TotalProgressLabel.Top := TotalProgressStaticText.Top;
  TotalProgressLabel.Left := TotalProgressBar.Width;
  TotalProgressLabel.Caption := '--/--';
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

procedure OnDirEditChange(Sender: TObject);
var
  S: string;
begin
  S := WizardDirValue;

  // string must not be empty
  if (Length(S) = 0) then MsgBox('Please enter a target folder for the installation.', mbError, MB_OK);

  // disallow installation into folders starting with "c:\windows"
  if(Pos(ExpandConstant('{win}'), S) > 0) then MsgBox('The installation into the windows folder is not allowed.', mbError, MB_OK);

  if(Pos(ExpandConstant('C:\Windows'), S) > 0) or (Pos(ExpandConstant('C:\windows'), S) > 0)
  or(Pos(ExpandConstant('c:\Windows'), S) > 0) or (Pos(ExpandConstant('c:\windows'), S) > 0)
  then MsgBox('The installation into the windows folder is not allowed.', mbError, MB_OK);

  // disallow installation into folders: program files
  if(Pos(ExpandConstant('{pf}'), S) > 0) then MsgBox('The installation into the program files folder is not allowed.', mbError, MB_OK);

  // disallow installation into folders: common files
  if(Pos(ExpandConstant('{cf}'), S) > 0) then MsgBox('The installation into the common files folder is not allowed.', mbError, MB_OK);

  // disallow installation into folders with spaces
  if(Pos(' ', S) > 0) then MsgBox('Your installation folder must not contain any spaces.', mbError, MB_OK);
end;

procedure InitializeWizard();
var
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

  // Display the Version Number as overlay on the WizardImageFile (banner-left)
  // Label for the WelcomePage
  VersionLabel            := TLabel.Create(WizardForm);
  VersionLabel.Top        := 43;
  VersionLabel.Left       := 129;
  VersionLabel.Caption    := ExpandConstant('{#APP_VERSION}');
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
  VersionLabel2.Caption    := ExpandConstant('{#APP_VERSION}');
  VersionLabel2.Font.Name  := 'Tahoma';
  VersionLabel2.Font.Size  := 7;
  VersionLabel2.Font.Style := [fsBold];
  VersionLabel2.Font.Color := $343434;
  VersionLabel2.Parent     := WizardForm.FinishedPage;

  // Display website link in the bottom left corner of the install wizard
  CancelBtn                := WizardForm.CancelButton;
  WebsiteButton            := TButton.Create(WizardForm);
  WebsiteButton.Top        := CancelBtn.Top;
  WebsiteButton.Left       := WizardForm.ClientWidth - CancelBtn.Left - CancelBtn.Width;
  WebsiteButton.Height     := CancelBtn.Height;
  WebsiteButton.Caption    := ExpandConstant('{cm:WebsiteButton}');
  WebsiteButton.Cursor     := crHand;
  WebsiteButton.Font.Color := clHighlight;
  WebsiteButton.OnClick    := @WebsiteButtonClick;
  WebsiteButton.Parent     := WizardForm;

  HelpButton               := TButton.Create(WizardForm);
  HelpButton.Top           := CancelBtn.Top;
  HelpButton.Left          := WebsiteButton.Left + WebsiteButton.Width;
  HelpButton.Height        := CancelBtn.Height;
  HelpButton.Caption       := ExpandConstant('{cm:HelpButton}');
  HelpButton.Cursor        := crHelp;
  HelpButton.Font.Color    := clHighlight;
  HelpButton.OnClick       := @HelpButtonClick;
  HelpButton.Parent        := WizardForm;

  // Show that Debug Mode is active
  if DEBUG = true then
  begin
    DebugLabel            := TNewStaticText.Create(WizardForm);
    DebugLabel.Top        := WebsiteButton.Top + 4;
    DebugLabel.Left       := WebsiteButton.Left + WebsiteButton.Width + 85;
    DebugLabel.Caption    := ExpandConstant('DEBUG ON');
    DebugLabel.Font.Style := [fsBold];
    DebugLabel.Parent     := WizardForm;
  end;

  // register OnChange event handling function for the "Select Destination Location" dialog
  // if the folder is not OK, force the user to fix it.
  WizardForm.DirEdit.OnChange := @OnDirEditChange;
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

  end; // of wpSelectComponents

  Result := True;
end;

Procedure GetNumberOfSelectedComponents(selectedComponents : String);
var
  i : Integer;
begin
  // determine the total number of components by counting the selected components.
  for i := 0 to WizardForm.ComponentsList.Items.Count - 1 do
    if WizardForm.ComponentsList.Checked[i] = true then
       intTotalComponents := intTotalComponents + 1;

  if (DEBUG = true) then Log('# The following [' + IntToStr(intTotalComponents) + '] components are selected: ' + selectedComponents);

  // the "serverstack" contains 3 components and is always installed. we have to add 2 to the counter.
  intTotalComponents := intTotalComponents + 2;

  // the following components contain 2 components. if selected, we have to add 1 to the counter.
  if Pos('assettools', selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1; // closure+yuicomp
  if Pos('git',        selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1; // gogs+msysgit
  if Pos('node',       selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1; // npm
  if Pos('imagick',    selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1; // phpext_imagick
  if Pos('mongodb',    selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1; // phpext_mongo
  if Pos('redis',      selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1; // phpext_redis

  // the component "PHP Extensions" contains 11 extensions. if selected, we have to add 10 to the counter.
  if Pos('phpextensions', selectedComponents) > 0 then intTotalComponents := intTotalComponents + 10;

  if (DEBUG = true) then Log('# Recalculated total number of components: [' + IntToStr(intTotalComponents) + ']');
end;

procedure UpdateTotalProgressBar();
{
  This procedure is called, when installing a component is finished.
  It updates the TotalProgessBar and the Label in the InstallationScreen with the new percentage.
}
var
    TotalProgressBar   : TNewProgressBar;
    TotalProgressLabel : TLabel;
begin
    TotalProgressBar := TNewProgressBar(InstallPage.FindComponent('TotalProgressBar'));

    {
      Initalize the ProgessBar
    }

    if(TotalProgressBar.Position = -1) then
    begin
        TotalProgressBar.Min := 0;
        TotalProgressBar.Position := 0;
        TotalProgressBar.Max := (intTotalComponents * 100);
        if (DEBUG = true) then Log('# ProgressBar.Max set to: [' + IntToStr(TotalProgressBar.Max) + '].');
    end;

    {
      Increase counter and update the ProgressBar accordingly
    }

    // increase counter
    intInstalledComponentsCounter := intInstalledComponentsCounter + 1;

    // Update Label
    TotalProgressLabel := TLabel(InstallPage.FindComponent('TotalProgressLabel'));
    TotalProgressLabel.Caption := IntToStr(intInstalledComponentsCounter) + '/' +IntToStr(intTotalComponents);

    // Update ProgressBar
    TotalProgressBar.Position := (intInstalledComponentsCounter * 100);

    if (DEBUG = true) then
    begin
      Log('# Processed Components '+IntToStr(intInstalledComponentsCounter) +'/'+IntToStr(intTotalComponents)+'.');
    end;
end;

{
  This procedure is called, when installing a new component starts.
  It updates the CurrentComponentLabel with the name of the component.
}
procedure UpdateCurrentComponentName(component: String);
var
    CurrentComponentLabel : TLabel;
begin
    CurrentComponentLabel := TLabel(InstallPage.FindComponent('CurrentComponentLabel'));
    CurrentComponentLabel.Caption := component;
    if (DEBUG = true) then Log('# Extracting Component: ' + component);
end;

{
  Called from DoPreInstall() before UnzipFiles().

  We extract some tools
}
procedure PrepareUnzip();
begin
  // extract unzip util from the compressed setup to temp folder
  ExtractTemporaryFile('7za.exe');

  // set application path as global variable
  appDir := ExpandConstant('{app}');

  // set "targetPath" for downloads or extractions to the temporary path
  // when the installation is finished, the temp folder gets cleared.
  targetPath := ExpandConstant('{tmp}\');

  // fetch the "hide console" command from the compressed setup and define a shortcut
  ExtractTemporaryFile('RunHiddenConsole.exe');
  hideConsole := targetPath + 'RunHiddenConsole.exe';

  // create missing folders
  ForceDirectories(appDir + '\bin');
  ForceDirectories(appDir + '\www\tools');
  ForceDirectories(appDir + '\docs\licenses');
end;

{
  Called from DoPreInstall() after PrepareUnzip().
}
procedure UnzipFiles();
var
  selectedComponents     : String;
begin
  selectedComponents := WizardSelectedComponents(false);

  GetNumberOfSelectedComponents(selectedComponents);

  // Update Progress Bars

  // always unzip the serverstack base (3 components)

  UpdateCurrentComponentName('Nginx');
    ExtractTemporaryFile(Filename_nginx);
    Unzip(targetPath + Filename_nginx, appDir + '\bin'); // no subfolder, because nginx brings own dir
    ExecHidden('cmd.exe /c "move /Y ' + appDir + '\bin\nginx-* ' + appDir + '\bin\nginx"'); // rename directory
  UpdateTotalProgressBar();

  UpdateCurrentComponentName('PHP');
    ExtractTemporaryFile(Filename_php);
    Unzip(targetPath + Filename_php, appDir + '\bin\php');
  UpdateTotalProgressBar();

  UpdateCurrentComponentName('MariaDB');
    ExtractTemporaryFile(Filename_mariadb);
    Unzip(targetPath + Filename_mariadb, appDir + '\bin'); // no subfolder, brings own dir
    ExecHidden('cmd.exe /c "move /Y ' + appDir + '\bin\mariadb-* ' + appDir + '\bin\mariadb"');  // rename directory
  UpdateTotalProgressBar();

  // unzip selected components

  if Pos('benchmark', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('WPN-XM Benchmark Tools');
      ExtractTemporaryFile(Filename_wpnxm_benchmark);
      Unzip(ExpandConstant(targetPath + Filename_wpnxm_benchmark), appDir); // multiple files and folders into top level
    UpdateTotalProgressBar();
  end;

  if Pos('conemu', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('ConEmu');
      ForceDirectories(appDir + '\bin\conemu\');
      ExtractTemporaryFile(Filename_conemu);
      Unzip(targetPath + Filename_conemu, appDir + '\bin\conemu');
    UpdateTotalProgressBar();
  end;

  if Pos('servercontrolpanel', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('WPN-XM Server Control Panel');
      ExtractTemporaryFile(Filename_wpnxm_scp);
      Unzip(ExpandConstant(targetPath + Filename_wpnxm_scp), appDir); // no subfolder, top level
    UpdateTotalProgressBar();
  end;

  if Pos('openssl', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('OpenSSL');
      ExtractTemporaryFile(Filename_openssl);
      Unzip(ExpandConstant(targetPath + Filename_openssl), appDir + '\bin\openssl');
    UpdateTotalProgressBar();
  end;
 
  if Pos('xdebug', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Xdebug');
      ExtractTemporaryFile(Filename_phpext_xdebug);
      Unzip(targetPath + Filename_phpext_xdebug, targetPath + 'phpext_xdebug');
      FileCopy(ExpandConstant(targetPath + 'phpext_xdebug\php_xdebug.dll'), appDir + '\bin\php\ext\php_xdebug.dll', false);

      ForceDirectories(appDir + '\www\tools\xdebug\');
      FileCopy(ExpandConstant(targetPath + 'phpext_xdebug\tracefile-analyser.php'), appDir + '\www\tools\xdebug\tracefile-analyser.php', false);
    UpdateTotalProgressBar();
  end;

  if Pos('pickle', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('pickle');
      ExtractTemporaryFile(Filename_pickle);       
      // pickle is not zipped. Its a PHP PHAR file.
      FileCopy(ExpandConstant(targetPath + Filename_pickle), appDir + '\bin\pickle\' + Filename_pickle, false);
    UpdateTotalProgressBar();
  end;

  // adminer is not zipped. its a php file. copy it to the target path.
  if Pos('adminer', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Adminer');
      ExtractTemporaryFile(Filename_adminer);
      ForceDirectories(appDir + '\www\tools\adminer\');
      FileCopy(ExpandConstant(targetPath + Filename_adminer), appDir + '\www\tools\adminer\' + Filename_adminer, false);
    UpdateTotalProgressBar();
  end;

  // composer is not zipped, its just a php phar package, so copy it to the php path
  if Pos('composer', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Composer');
      ExtractTemporaryFile(Filename_composer);
      FileCopy(ExpandConstant(targetPath + Filename_composer), appDir + '\bin\composer\' + Filename_composer, false);
    UpdateTotalProgressBar();
  end;

end;

{
   DoPreInstall will be called after the user clicks Next on the wpReady page,
   but before Inno installs any of the [Files] and other standard script items.
   Its triggered by CurStep == ssInstall in procedure CurStepChanged().
   Workflow: wpReady to Install -> Click Next (Triggers ssInstall) -> wpInstalling
}
procedure DoPreInstall();
begin
  PrepareUnzip();
  UnzipFiles();
end;

procedure Configure();
var
  selectedComponents: String;
  appDirWithSlashes : String; // some servers (e.g. maria) expect linux paths in config files
  php_ini_file : String;
  mariadb_ini_file : String;
begin
  selectedComponents := WizardSelectedComponents(false);

  // StringChange(S,FromStr,ToStr) works on the string S, changing all occurances in S of FromStr to ToStr.
  appDirWithSlashes := appDir;
  StringChange(appDirWithSlashes, '\', '/');

  {
    =============== Inital Setup for Components (post-install commands) ===============
  }

  // MariaDb - install with user ROOT and without password (this is the position to add a default password)
  ExecHidden(appDir + '\bin\mariadb\bin\mysql_install_db.exe --datadir="' + appDir + '\bin\mariadb\data" --default-user=root --password=');

  // MariaDB - initialize mysql tables, e.g. performance_tables
  ExecHidden(appDir + '\bin\mariadb\bin\mysql_upgrade.exe');

  {
    =============== Modify Configuration Files ===============
  }

  // config files
  php_ini_file := appDir + '\bin\php\php.ini';
  mariadb_ini_file := appDir + '\bin\mariadb\my.ini';

  // http://dev.mysql.com/doc/refman/5.5/en/server-options.html#option_mysqld_log-error
  // waring: mysqld will not start if backslashes (\) are used. fwd slashes (/) needed!
  SetIniString('mysqld', 'log-error',        appDirWithSlashes + '/logs/mariadb_error.log',  mariadb_ini_file);

  // PHP
  ReplaceStringInFile('error_log = php_error.log',
                      'error_log = ' + appDir + '\logs\php_error.log', php_ini_file);

  ReplaceStringInFile(';upload_tmp_dir =',           'upload_tmp_dir = ' + appDir + '\temp',    php_ini_file);
  ReplaceStringInFile('upload_max_filesize = 2M',    'upload_max_filesize = 8M',                php_ini_file);
  ReplaceStringInFile(';session.save_path = "/tmp"', 'session.save_path = ' + appDir + '\temp', php_ini_file);

  ReplaceStringInFile(';zend_extension=php_opcache.dll',
                      'zend_extension=' + appDir + '\bin\php\ext\php_opcache.dll', php_ini_file);

  if Pos('xdebug', selectedComponents) > 0 then
  begin
      ReplaceStringInFile(';zend_extension=php_xdebug.dll',
                          'zend_extension=' + appDir + '\bin\php\ext\php_xdebug.dll', php_ini_file);
  end;

  if Pos('webgrind', selectedComponents) > 0 then
  begin
	ReplaceStringInFile('xdebug.profiler_enable         = 0', 'xdebug.profiler_enable         = 1', php_ini_file);

    ReplaceStringInFile(';xdebug.profiler_output_dir    = "C:\server\logs"',
                        'xdebug.profiler_output_dir     = "' + appDir + '\logs"', php_ini_file);
  end;

  if Pos('openssl', selectedComponents) > 0 then
  begin
    ReplaceStringInFile(';curl.cainfo =', 'curl.cainfo =' + appDir + '\bin\openssl\ca-bundle.crt', php_ini_file);
    ReplaceStringInFile(';openssl.cafile =', 'openssl.cafile =' + appDir + '\bin\openssl\ca-bundle.crt', php_ini_file);
  end;

end;

{
  DoPostInstall will be called after Inno has completed installing all of
  the [Files], [Registry] entries, and so forth, and also after all the
  non-postinstall [Run] entries, but before the wpInfoAfter or wpFinished pages.
  Its triggerd by CurStep == ssPostInstall. See procedure CurStepChanged().
  wpInstalling Install finshed -> ssPostInstall
}
procedure DoPostInstall();
begin
  Configure()
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssInstall then DoPreInstall();
  if CurStep = ssPostInstall then DoPostInstall();

  // when the wizard finishes, copy the installation logfile from tmp dir to application dir.
  // this allows easier debugging of installation problems. the user can upload or reference parts of the log.
  if CurStep = ssDone then
      filecopy(ExpandConstant('{log}'), ExpandConstant('{app}\logs\') + ExtractFileName(ExpandConstant('{log}')), false);
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  // show custom wpInstalling page with two progress bars.
  if CurPageID=wpInstalling then CustomWpInstallingPage();
end;

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
function IsModuleLoaded(modulename: AnsiString) : Boolean;
external 'IsModuleLoaded@{app}\bin\tools\psvince.dll stdcall uninstallonly';

function ProcessesRunningWhenUninstall(): Boolean;
var
  index : Integer;
  processes: Array [1..6] of String;
begin
  // fill processes array with process executables to look for
  processes[1] := 'nginx.exe';
  processes[2] := 'memcached.exe';
  processes[3] := 'php-cgi.exe';
  processes[4] := 'mysqld.exe';
  processes[5] := 'mongod.exe';
  processes[6] := 'postgres.exe';

  // method return value defaults to false, meaning that no processes is running
  Result := false;

  // iterate processes
  for index := 1 to 6 do
  begin
    // and check if process is running (using external call to psvince.dll)
    if ( IsModuleLoaded( processes[index] ) = true ) then
    begin
     MsgBox( processes[index] + ' is running, please close it and run again uninstall.', mbError, MB_OK );
     Result := true;
    end;

  end;
end;

function InitializeUninstall(): Boolean;
var
  ErrorCode: Integer;
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
      if Exec('cmd.exe', '/c ' + ExpandConstant('{app}\stop.bat'), '', SW_HIDE,
         ewWaitUntilTerminated, ErrorCode) then
      begin
        Result := ErrorCode > 0;
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

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin

  // open uninstall survey in browser on (non-silent) uninstallation
  if (IsUninstaller and not UninstallSilent) then begin
    if (CurUninstallStep = usDone) then begin
          OpenBrowser('http://wpn-xm.org/uninstall-survey.php?version=' + ExpandConstant('{#APP_VERSION}'));
    end;
  end;

  // warn the user, that his working folder is going to be deleted and projects might get lost
  if (CurUninstallStep = usUninstall) then begin
    if MsgBox('***WARNING***'#13#10#13#10 +
        'The WPN-XM installation folder is [ '+ ExpandConstant('{app}') +' ].'#13#10 +
        'You are about to delete this folder and all its subfolders,'#13#10 +
        'including [ '+ ExpandConstant('{app}') +'\www ], which may contain your projects.'#13#10#13#10 +
        'This is your last chance to do a backup of your files.'#13#10#13#10 +
        'Do you want to proceed?'#13#10, mbConfirmation, MB_YESNO) = IDYES
    then begin
      // User clicked: YES

      // fix "read-only" status of all files and folders, else some things might remain after uninstallation
      ExecHidden('cmd.exe /c "attrib -R ' + appDir + '\*.* /s /d"');

      // Deletes the application directory and everything inside it.
      // This function will remove directories that are reparse points,
      // but it will not recursively delete files/directories inside them.
      DelTree(ExpandConstant('{app}'), True, True, True);

      // Removing a path from the environment PATH variable works in 3 steps (see includes/envpath.iss):
      // 1. get the old env var PATH and store it temporarily in oldPath
      SaveOldPathCurrentUser();

    end else begin
      // User clicked: No
      Abort;
    end;
  end;

  // 2. remove paths from the env var PATH 
  if (CurUninstallStep = usPostUninstall) then begin
     RemovePathCurrentUser(appDir + '\bin\php');
     RemovePathCurrentUser(appDir + '\bin\php\ext');
     RemovePathCurrentUser(appDir + '\bin\mariadb\bin');
     // 3. refresh environment, so that the modified PATH var is activated
     RefreshEnvironment();
  end;
end;