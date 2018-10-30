@echo off
echo InputFile: '%1'
echo OutputFile: '%2'

REM xmlMind tool to RTF
REM -------------------

REM SET PATH="C:\Program Files\XMLmind FO Converter";"C:\Program Files\Oracle\jre\1.1.7\bin";c:\windows\system32
REM CALL FO2RTF %1 > %2


REM xmlMind tool to WML
REM -------------------

SET PATH="C:\Program Files\XMLmind FO Converter";"C:\Program Files\Oracle\jre\1.1.7\bin";c:\windows\system32
CALL FO2WML %1 > %2


REM Apache Fop Tool
REM ------------

REM SET PATH="D:\FOP\fop-0.20.5";"C:\Program Files\Oracle\jre\1.1.7\bin";c:\windows\system32
REM CALL FOP %1 %2