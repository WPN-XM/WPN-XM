@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Start MongoDb
:: |
:: +-----------------------------------------------------------------------<3

cls

IF NOT EXIST "%~dp0bin\mongodb\data" (
    echo .
    echo Creating Directory for MongoDB's Database - \data
    mkdir "%~dp0bin\mongodb\data"
)


IF NOT EXIST "%~dp0bin\mongodb\data\db" (
    echo .
    echo Creating Directory for MongoDB's Database - \data\db
    mkdir "%~dp0bin\mongodb\data\db"
)

IF NOT EXIST "%~dp0logs\mongodb.log" (
    echo.
    echo Creating empty logfile... "%~dp0logs\mongodb.log"
    echo. 2>"%~dp0logs\mongodb.log"
)

IF EXIST "%cd%\data\mongod.lock" (
    echo.
    echo Deleting previous .lock file leved from last unclean MongoDB shutdown...
    del 2>"%cd%\data\mongod.lock"
)

echo.
echo Starting MongoDB
     %~dp0bin\mongodb\bin\mongod.exe --config "%~dp0bin\mongodb\mongodb.conf" --logpath "%~dp0logs\mongodb.log" --dbpath "%~dp0bin\mongodb\data\db"
echo.

pause
