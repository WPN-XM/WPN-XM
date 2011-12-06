//
//    WPN-XM Server Stack
//
//    WPN-XM is a free and open-source web server solution stack for 
//    professional PHP development on the Windows platform.
//
//    The groundation of this stack consists of NGINX, MariaDb and PHP.
//    The stack contains several additional tools you might install:
//    - Xdebug, Xhprof, webgrind for php debugging purposes,
//    - phpMyAdmin for MySQL database administration,
//    - memcached and APC for caching purposes.
//
//    Author:   Jens-Andre Koch <jakoch@web.de>
//    Website:  http://wpn-xm.org
//    License:  GNU/GPLv2+
//

# define SOURCE_ROOT AddBackslash(SourcePath);

// we need to include the Sherlock Software\InnoTools\Downloader
# include SOURCE_ROOT + "bin\InnoToolsDownloader\it_download.iss"

[Setup]
AppId={{8E0B8E63-FF85-4B78-9C7F-109F905E1D3B}}
AppName=WPN-XM Server Stack
AppVerName="WPN-XM Server Stack 0.1"
AppVersion=0.1
AppPublisher="Jens-André Koch"
AppCopyright=© Jens-André Koch
AppPublisherURL="http://wpn-xm.org"
AppSupportURL="https://github.com/jakoch/WPN-XM/issues/"
AppUpdatesURL="http://wpn-xm.org"
// default installation folder is "c:\server". but user might change this via dialog.
DefaultDirName={sd}\server
DefaultGroupName="WPN-XM Server Stack"
OutputBaseFilename="WPNXM-0.1"
Compression=lzma/ultra
InternalCompressLevel=max
SolidCompression=true
CreateAppDir=true
ShowLanguageDialog=no
BackColor=clBlack
VersionInfoVersion=0.1
SetupIconFile={#SOURCE_ROOT}Setup.ico
//WizardImageFile={#SOURCE_ROOT}wizardimage.bmp
//WizardSmallImageFile={#SOURCE_ROOT}wizardsmallimage.bmp

[Languages]
Name: en; MessagesFile: compiler:Default.isl
Name: de; MessagesFile: compiler:languages\German.isl

[Types]
Name: "full"; Description: "Full installation"
Name: "serverstack"; Description: "Server Stack with Administration Tools"
Name: "debug"; Description: "Server Stack with Debugtools"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Components]
Name: "serverstack"; Description: "Base of the WPN-XM Server Stack (Nginx & PHP & MariaDb)"; ExtraDiskSpaceRequired: 155000000; Types: full serverstack debug custom; Flags: fixed
Name: "webinterface"; Description: "WPN-XM - Webinterface for Serveradministration"; ExtraDiskSpaceRequired: 500000; Types: full serverstack debug
Name: "consoleinterface"; Description: "WPN-XM - Tray App for Serveradministration"; ExtraDiskSpaceRequired: 500000; Types: full serverstack debug
Name: "xdebug"; Description: "Xdebug - PHP Extension for Debugging"; ExtraDiskSpaceRequired: 300000; Types: full debug
Name: "webgrind"; Description: "Webgrind - Xdebug profiling web frontend"; ExtraDiskSpaceRequired: 500000; Types: full debug
Name: "xhprof"; Description: "XhProfiler - Hierarchical Profiler for PHP"; ExtraDiskSpaceRequired: 800000; Types: full debug
// memcached install means the daemon and the php extension
Name: "memcached"; Description: "Memcached - distributed memory caching"; ExtraDiskSpaceRequired: 400000; Types: full
Name: "phpmyadmin"; Description: "phpMyAdmin - MySQL database administration webinterface"; ExtraDiskSpaceRequired: 3300000; Types: full

[Files]
// tools
Source: "bin\UnxUtils\unzip.exe"; DestDir: "{tmp}"; Flags: dontcopy
Source: "bin\HideConsole\RunHiddenConsole.exe"; DestDir: "{app}\bin\tools\"
Source: "bin\killprocess\Process.exe"; DestDir: "{app}\bin\tools\"
Source: "cleanup-mysql-5.5.15-win32.bat"; DestDir: "{tmp}"
// incorporate the whole "www" folder into the setup
Source: "www\*"; DestDir: "{app}\www";  Flags: recursesubdirs; Excludes: "*\nbproject*"
// incorporate several startfiles
Source: "startfiles\administration.url"; DestDir: "{app}"
Source: "startfiles\localhost.url"; DestDir: "{app}"
Source: "startfiles\start-wpnxm.exe"; DestDir: "{app}"
Source: "startfiles\stop-wpnxm.exe"; DestDir: "{app}"
Source: "startfiles\status-wpnxm.bat"; DestDir: "{app}"
// config files
Source: "configs\php.ini"; DestDir: "{app}\bin\php"
Source: "configs\nginx.conf"; DestDir: "{app}\bin\nginx\conf"
Source: "configs\vhosts.conf"; DestDir: "{app}\bin\nginx\conf"
Source: "configs\my.ini"; DestDir: "{app}\bin\mariadb"

[Icons]
Name: "{group}\Start WPN-XM"; Filename: "{app}\start-wpnxm.exe"
Name: "{group}\Stop WPN-XM"; Filename: "{app}\stop-wpnxm.exe"
Name: "{group}\Status of WPN-XM"; Filename: "{app}\status-wpnxm.bat"
Name: "{group}\Localhost"; Filename: "{app}\localhost.url"
Name: "{group}\Administration"; Filename: "{app}\administration.url"
Name: "{group}\{cm:RemoveApp}"; Filename: "{uninstallexe}"
//Name: "{userdesktop}\My Program"; Filename: "{app}\start-wpnxm.exe"; Tasks: desktopicon
//Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\WPN-XM"; Filename: "{app}\start-wpnxm.exe"; Tasks: quicklaunchicon

[Tasks]
//Name: "quicklaunchicon"; Description: "Create a &Quick Launch icon"; GroupDescription: "Additional icons:"; Flags: unchecked
//Name: "desktopicon"; Description: "Create a &Desktop icon"; GroupDescription: "Additional icons:"; Flags: unchecked

[Run]
// Automatically started...
Filename: "{tmp}\cleanup-mysql-5.5.15-win32.bat"; Parameters: "{app}\bin\mariadb";
//Filename: "{app}\SETUP.EXE"; Parameters: "/x"
// User selected... these files are shown for launch after everything is done
//Filename: "{app}\README.TXT"; Description: "View the README file"; Flags: postinstall shellexec skipifsilent
//Filename: "{app}\SETUP.EXE"; Description: "Configure Server Stack"; Flags: postinstall nowait skipifsilent unchecked

[INI]
;Filename: {app}\php\php.ini,Section: PHP; Key: extenson; String: php_pdo_mysql.dll; Components: ;

[CustomMessages]
de.WebsiteLink=http://wpn-xm.org
en.WebsiteLink=http://wpn-xm.org
de.RemoveApp=WPN-XM Server Stack deinstallieren
en.RemoveApp=Uninstall WPN-XM Server Stack

[Dirs]
Name: "{app}\www"

[Code]
// Constants and global variables
const
  // DEBUG Toggle
  //DEBUG = false;
  DEBUG = true;

  // Define download URLs for the software packages
  // Warning: Watch the protocol (Use http, not https!), if you add download links pointing to github. 
  URL_nginx             = 'http://www.nginx.org/download/nginx-1.1.10.zip';
  URL_php               = 'http://windows.php.net/downloads/releases/php-5.3.8-nts-Win32-VC9-x86.zip';
  URL_mariadb           = 'http://mirror2.hs-esslingen.de/mariadb/mariadb-5.3.2-beta/win2008r2-vs2010-i386-packages/mariadb-5.3.2-beta-win32.zip';
  URL_phpext_xdebug     = 'http://xdebug.org/files/php_xdebug-2.1.2-5.3-vc9-nts.dll';
  URL_webgrind          = 'http://webgrind.googlecode.com/files/webgrind-release-1.0.zip';
  // Leave the original url of xhprof in here ! we are fetching from paul reinheimers fork !
  //URL_xhprof          = 'http://nodeload.github.com/facebook/xhprof/zipball/master';
  URL_xhprof            = 'http://nodeload.github.com/preinheimer/xhprof/zipball/master';
  URL_memcached         = 'http://downloads.northscale.com/memcached-1.4.5-x86.zip';
  URL_phpext_memcached  = 'http://downloads.php.net/pierre/php_memcache-2.2.6-5.3-vc9-x86.zip';
  URL_phpmyadmin        = 'http://netcologne.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/3.4.8/phpMyAdmin-3.4.8-english.zip';

  // Define file names for the downloads
  Filename_nginx            = 'nginx.zip';
  Filename_php              = 'php.zip';
  Filename_mariadb          = 'mariadb.zip';
  Filename_phpext_xdebug    = 'xdebug.dll';
  Filename_webgrind         = 'webgrind.zip';
  Filename_xhprof           = 'xhprof.zip';
  Filename_memcached        = 'memcached.zip';
  Filename_phpext_memcached = 'phpext_memcache.zip'; // memcache without D
  Filename_phpmyadmin       = 'phpmyadmin.zip';

var
  unzipTool: String;    // path+filename of unzip helper for exec
  returnCode: Integer;  // errorcode
  targetPath: String;   // if debug true will download to app/downloads, else temp dir

procedure UrlLabelClick(Sender: TObject);
var
  errorCode : integer;
begin
  ShellExec('','http://wpn-xm.org/','','', SW_SHOWNORMAL, ewNoWait, errorCode);
end;

procedure InitializeWizard();
var
  UrlLabel  : TNewStaticText;
  CancelBtn : TButton;
begin

  // download target path depends on debug constant
  if DEBUG = false then
  begin
    // Initialize InnoTools Download Helper
    itd_init;
    // Change from a simple overall progress bar to the detailed download view
    itd_setoption('UI_DetailedMode', '1');
    // when download fails, do not allow continuing with the installation
    itd_setoption('UI_AllowContinue', '0');
    // Start the download after the "Ready to install" screen is shown
    itd_downloadafter(wpReady);
    // reset files to download
    itd_clearfiles();
  end;

  // when debug enabled, do a one-time download of all components to a local folder
  if (DEBUG = true) and (FileExists(expandconstant('c:\wpnxm-downloads\nginx.zip')) = false) then
  begin
    // re-create the server stack folder
    if not DirExists(ExpandConstant('c:\wpnxm-downloads')) then ForceDirectories(ExpandConstant('c:\wpnxm-downloads'));
    // Initialize InnoTools Download Helper
    itd_init;
    // Change from a simple overall progress bar to the detailed download view
    itd_setoption('UI_DetailedMode', '1');
    // when download fails, do not allow continuing with the installation
    itd_setoption('UI_AllowContinue', '0');
    // Start the download after the "Ready to install" screen is shown
    itd_downloadafter(wpReady);
    // reset files to download
    itd_clearfiles();
  end;

 // display website link in the bottom left corner of the install wizard
 CancelBtn := WizardForm.CancelButton;
 UrlLabel      := TNewStaticText.Create(WizardForm);
 UrlLabel.Top  := CancelBtn.Top + (CancelBtn.Height div 2) - (UrlLabel.Height div 2);
 UrlLabel.Left := WizardForm.ClientWidth - CancelBtn.Left - CancelBtn.Width;
 UrlLabel.Caption    := ExpandConstant('{cm:WebsiteLink}');
 UrlLabel.Font.Style := UrlLabel.Font.Style + [fsUnderline];
 UrlLabel.Cursor     := crHand;
 UrlLabel.Font.Color := clHighlight;
 UrlLabel.OnClick    := @UrlLabelClick;
 UrlLabel.Parent     := WizardForm;

 if DEBUG = true then  UrlLabel.Caption  := 'DEBUG ON    ' + UrlLabel.Caption;
end;

function NextButtonClick(CurPage: Integer): Boolean;
begin
  if CurPage = wpSelectComponents then
  begin

    if DEBUG = false then
    begin
      // using this path, the downloaded components are deleted after installation
      targetPath := expandconstant('{tmp}\');
    end else
    begin
      // using this path, the downloaded components are not deleted after installation
      targetPath := expandconstant('c:\wpnxm-downloads\');
    end;

    // add files to download handler

    if IsComponentSelected('serverstack') then
    begin
      itd_addfile(URL_nginx, expandconstant(targetPath + Filename_nginx));
      itd_addfile(URL_php, expandconstant(targetPath + Filename_php));
      itd_addfile(URL_mariadb, expandconstant(targetPath + Filename_mariadb));
    end;

    if IsComponentSelected('xdebug')    then itd_addfile(URL_phpext_xdebug, expandconstant(targetPath + Filename_phpext_xdebug));
    if IsComponentSelected('webgrind')  then itd_addfile(URL_webgrind,      expandconstant(targetPath + Filename_webgrind));
    if IsComponentSelected('xhprof')    then itd_addfile(URL_xhprof,        expandconstant(targetPath + Filename_xhprof));
    if IsComponentSelected('memcached') then
    begin
        itd_addfile(URL_memcached,          expandconstant(targetPath + Filename_memcached));
        itd_addfile(URL_phpext_memcached,   expandconstant(targetPath + Filename_phpext_memcached));
    end;

    if IsComponentSelected('phpmyadmin') then itd_addfile(URL_phpmyadmin,   expandconstant(targetPath + Filename_phpmyadmin));

  end;

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

procedure UnzipFiles();
var
  selectedComponents: String;
begin
  selectedComponents := WizardSelectedComponents(false);

  // lets fetch the unzip command from the compressed setup
  ExtractTemporaryFile('unzip.exe');

  if not DirExists(ExpandConstant('{app}\bin')) then ForceDirectories(ExpandConstant('{app}\bin'));
  if not DirExists(ExpandConstant('{app}\www')) then ForceDirectories(ExpandConstant('{app}\www'));

  // always unzip the serverstack base

  DoUnzip(targetPath + Filename_nginx, ExpandConstant('{app}\bin')); // no subfolder, because nginx brings own dir

  DoUnzip(targetPath + Filename_php, ExpandConstant('{app}\bin\php'));

  DoUnzip(targetPath + Filename_mariadb, ExpandConstant('{app}\bin')); // no subfolder, brings own dir

  // unzip selected components

  // xdebug is not a zipped, its just a dll file, so copy it to the target path
  if Pos('xdebug', selectedComponents) > 0 then FileCopy(ExpandConstant(targetPath + Filename_phpext_xdebug), ExpandConstant('{app}\bin\php\ext\php_xdebug.dll'), false);

  if Pos('webgrind', selectedComponents) > 0 then DoUnzip(targetPath + Filename_webgrind, ExpandConstant('{app}\www')); // no subfolder, brings own dir

  if Pos('xhprof', selectedComponents) > 0 then DoUnzip(targetPath + Filename_xhprof, ExpandConstant('{app}\www')); // no subfolder, brings own dir

  if Pos('memcached', selectedComponents) > 0 then
  begin
    DoUnzip(targetPath + Filename_memcached, ExpandConstant('{app}\bin')); // no subfolder, brings own dir
    DoUnzip(targetPath + Filename_phpext_memcached, ExpandConstant('{app}\bin\php\ext'));
  end;

  if Pos('phpmyadmin', selectedComponents) > 0 then DoUnzip(targetPath + Filename_phpmyadmin, ExpandConstant('{app}\www')); // no subfolder, brings own dir

end;

procedure ApplyModifications();
var
  php_ini_file : String;
  selectedComponents: String;
begin
  selectedComponents := WizardSelectedComponents(false);

  // config files

  php_ini_file := ExpandConstant('{app}\bin\php\php.ini');

  // modifications to the config files

  // nginx - rename directory
  Exec('cmd.exe', '/c "move ' + ExpandConstant('{app}\bin\nginx-*') + ' ' + ExpandConstant('{app}\bin\nginx') + '"',
  '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);

  // mariadb - rename directory
  Exec('cmd.exe', '/c "move ' + ExpandConstant('{app}\bin\mariadb-*') + '  ' + ExpandConstant('{app}\bin\mariadb') + '"',
   '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);

  // php
  SetIniString('PHP', 'error_log',            ExpandConstant('{app}\logs') + '\php_error.log', php_ini_file );
  SetIniString('PHP', 'doc_root',             ExpandConstant('{app}\www'), php_ini_file );
  SetIniString('PHP', 'include_path',         ExpandConstant('{app}\bin\php\pear'), php_ini_file );
  SetIniString('PHP', 'upload_tmp_dir',       ExpandConstant('{app}\temp'), php_ini_file );
  SetIniString('PHP', 'upload_max_filesize',  '8M', php_ini_file );
  SetIniString('PHP', 'session.save_path',    ExpandConstant('{app}\temp'), php_ini_file );

  // xdebug
  if Pos('xdebug', selectedComponents) > 0 then
  begin
      // add loading of xdebug.dll to php.ini
      if not IniKeyExists('Zend', 'zend_extension', php_ini_file) then
      begin
          SetIniString('Zend', 'zend_extension', ExpandConstant('{app}\bin\php\ext\php_xdebug.dll'), php_ini_file );
      end;

      // activate remote debugging
      SetIniString('Xdebug', 'xdebug.remote_enable',  'on', php_ini_file );
      SetIniString('Xdebug', 'xdebug.remote_handler', 'dbgp', php_ini_file );
      SetIniString('Xdebug', 'xdebug.remote_host',    'localhost', php_ini_file );
      SetIniString('Xdebug', 'xdebug.remote_port',    '9000', php_ini_file );
  end;

  if Pos('xhprof', selectedComponents) > 0 then
  begin
    // deactivated, because we are fetching from preinheimer's fork, see below
    // xhprof - rename "facebook-xhprof-gitref" directory
    //Exec('cmd.exe', '/c "move ' + ExpandConstant('{app}\www\facebook-xhprof*') + '  ' + ExpandConstant('{app}\www\xhprof') + '"', 
    //'', SW_SHOW, ewWaitUntilTerminated, ReturnCode);

    // xhprof - rename "preinheimer-xhprof-gitref" directory
    Exec('cmd.exe', '/c "move ' + ExpandConstant('{app}\www\preinheimer-xhprof*') + '  ' + ExpandConstant('{app}\www\xhprof') + '"', 
    '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);
  end;

  if Pos('memcached', selectedComponents) > 0 then
  begin
      // rename the existing directory
      Exec('cmd.exe', '/c "move ' + ExpandConstant('{app}\bin\memcached-x86') + ' ' + ExpandConstant('{app}\bin\memcached') + '"',
      '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);

      // php.ini entry for loading the the extension
      SetIniString('PHP', 'extension', 'php_memcache.dll', php_ini_file );
  end;

  if Pos('phpmyadmin', selectedComponents) > 0 then
  begin
     // phpmyadmin - rename "phpMyAdmin-3.4.6-english" directory
    Exec('cmd.exe', '/c "move ' + ExpandConstant('{app}\www\phpMyAdmin-*') + '  ' + ExpandConstant('{app}\www\phpmyadmin') + '"',
    '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);
  end;

end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
 if CurStep=ssInstall then
   begin
    UnzipFiles();
    ApplyModifications();
   end;
end;
