@echo off
cls
REM: Command File Created by Microsoft Visual Database Tools
REM: Date Generated: 12/09/2005
REM: Authentication type: Windows NT
REM: Usage: CommandFilename

Echo CREATE DATABASE..
osql -S localhost -d Master -E -b  -i "Database\Database.sql"
if %ERRORLEVEL% NEQ 0 goto errors

Echo CREATE TABLES..
osql -S localhost -d Salt_Migration -E -b  -i "Table\tblExtract.TAB"
if %ERRORLEVEL% NEQ 0 goto errors
osql -S localhost -d Salt_Migration -E -b  -i "Table\tblLoad.TAB"
if %ERRORLEVEL% NEQ 0 goto errors
osql -S localhost -d Salt_Migration -E -b  -i "Table\tblTranslate_Module.TAB"
if %ERRORLEVEL% NEQ 0 goto errors
osql -S localhost -d Salt_Migration -E -b  -i "Table\tblTranslate_User.TAB"
if %ERRORLEVEL% NEQ 0 goto errors

Echo CREATE PROCEDURES..
osql -S localhost -d Salt_Migration -E -b  -i "Procedure\prcExtract.sql"
if %ERRORLEVEL% NEQ 0 goto errors
osql -S localhost -d Salt_Migration -E -b  -i "Procedure\prcImport_Translation_User.sql"
if %ERRORLEVEL% NEQ 0 goto errors
osql -S localhost -d Salt_Migration -E -b  -i "Procedure\prcImportUserResult.sql"
if %ERRORLEVEL% NEQ 0 goto errors
osql -S localhost -d Salt_Migration -E -b  -i "Procedure\prcImportUserResults.sql"
if %ERRORLEVEL% NEQ 0 goto errors
osql -S localhost -d Salt_Migration -E -b  -i "Procedure\prcTestData.sql"
if %ERRORLEVEL% NEQ 0 goto errors
osql -S localhost -d Salt_Migration -E -b  -i "Procedure\prcTranslate.sql"
if %ERRORLEVEL% NEQ 0 goto errors
osql -S localhost -d Salt_Migration -E -b  -i "Procedure\prcValidate.sql"
if %ERRORLEVEL% NEQ 0 goto errors

goto finish


REM: error handler
:errors
echo.
echo WARNING! Error(s) were detected!
echo --------------------------------
pause
goto done

REM: finished execution
:finish
echo SUCCESS
pause
:done
@echo on
