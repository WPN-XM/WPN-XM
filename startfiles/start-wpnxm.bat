@echo off

if exist "%cd%\temp" (
	RD "%cd%\temp\" /S /Q
)

if not exist "%cd%\temp" (
    echo Creating Directories for Temporary Files...
    mkdir "%cd%\temp"
)

if not exist "%cd%\logs" (
    echo Creating Directories for Logs...
    mkdir "%cd%\logs"
)

SET HIDECONSOLE=%cd%\bin\tools\RunHiddenConsole.exe

:: start all daemons, if no argument given (default)
if "%1"=="" (
    call:start-php
    call:start-mariadb
    call:start-memcached
    call:start-nginx
    call:start-browser
) else (
    :: start specific daemon
    :: where $1 is the first cli argument, e.g. "start-wpnxm.bat php"
    call:start-%1
)
goto END

:: the start functions

:start-php
    echo Starting PHP FastCGI...
    %HIDECONSOLE% %cd%\bin\php\php-cgi.exe -b 127.0.0.1:9100 -c %cd%\bin\php\php.ini
    echo.
goto END

:start-mariadb
    echo Starting MariaDb...
    %HIDECONSOLE% %cd%\bin\mariadb\bin\mysqld.exe --defaults-file=%cd%\bin\mariadb\my.ini
    echo.
goto END

:start-memcached
    echo Starting Memcached...
    %HIDECONSOLE% %cd%\bin\memcached\memcached.exe -p 11211 -U 0 -t 2 -c 2048 -m 2048
    echo.
goto END

:start-nginx
    echo Starting nginx...
    %HIDECONSOLE% %cd%\bin\nginx\nginx.exe -p %cd% -c %cd%\bin\nginx\conf\nginx.conf
    echo.
goto END

:start-browser
    echo Opening localhost in Browser...
    start http://localhost/
goto END

goto END

:ERROR
pause>nul

:END
