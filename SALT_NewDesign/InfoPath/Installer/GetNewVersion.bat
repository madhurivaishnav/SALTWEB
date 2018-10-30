@echo off
rem This batch file registers all new infopath file, and copy to installer folder for package
Rem Before run this, please rebuild all project files
Rem usage: GetNewVersion VersionNumber

if "%1"=="" goto UseageHelp

echo ---- 1. Process Lesson form ----
echo Delete old lesson register file
del  ..\Lesson\Bin\Release\Lesson.bak
del  ..\Lesson\Bin\Release\Lesson.js
echo Register lesson form
regform /U urn:Lesson:Salt:Bdw /T Yes /V %1 ..\Lesson\Bin\Release\Lesson.xsn
echo Copy lesson form to installer folder
copy ..\Lesson\Bin\Release\Lesson.xsn .


echo ---- 2. Process Quiz form ----
echo Delete old Quiz register file
del  ..\Quiz\Bin\Release\Quiz.bak
del  ..\Quiz\Bin\Release\Quiz.js
echo Register Quiz form
regform /U urn:Quiz:Salt:Bdw /T Yes /V %1 ..\Quiz\Bin\Release\Quiz.xsn
echo Copy Quiz form to installer folder
copy ..\Quiz\Bin\Release\Quiz.xsn .


echo ---- 3. Process Phrases form ----
echo Delete old Phrases register file
del  ..\Phrases\Bin\Release\Phrases.bak
del  ..\Phrases\Bin\Release\Phrases.js
echo Register Phrases form
regform /U urn:Phrases:Salt:Bdw /T Yes /V %1 ..\Phrases\Bin\Release\Phrases.xsn
echo Copy Phrases form to installer folder
copy ..\Phrases\Bin\Release\Phrases.xsn .

goto end

: UseageHelp
echo This batch file registers all new infopath file, and copy to installer folder for package
echo Usage: GetNewVersion VersionNumber
echo Example: GetNewVersion 1.0.0.1
goto end

:end

