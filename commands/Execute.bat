@ECHO off

SET mypath=%~dp0..
cd %mypath%

:: Execute java passing classpath
java -cp .\bin src.app

PAUSE
EXIT