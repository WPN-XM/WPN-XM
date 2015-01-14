@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Start MongoDb
:: |
:: +-----------------------------------------------------------------------<3

cls

IF NOT EXIST "%cd%\bin\mongodb\data" (
    echo .
    echo Creating Directory for MongoDB's Database - \data
    mkdir "%cd%\bin\mongodb\data"
)


IF NOT EXIST "%cd%\bin\mongodb\data\db" (
    echo .
    echo Creating Directory for MongoDB's Database - \data\db
    mkdir "%cd%\bin\mongodb\data\db"
)

IF NOT EXIST "%cd%\logs\mongodb.log" (
    echo.
    echo Creating empty logfile... "%cd%\logs\mongodb.log"
    echo. 2>"%cd%\logs\mongodb.log"
)

IF EXIST "%cd%\data\mongod.lock" (
    echo.
    echo Deleting previous .lock file leved from last unclean MongoDB shutdown...
    del 2>"%cd%\data\mongod.lock"
)

echo.
echo Starting MongoDB
     %cd%\bin\mongodb\bin\mongod.exe --config "%cd%\bin\mongodb\mongodb.conf" --logpath "%cd%\logs\mongodb.log" --dbpath "%cd%\bin\mongodb\data\db"
echo.

pause
