@ECHO off

SET mypath=%~dp0..\bin
cd %mypath%

:: Execute java passing classpath
java -jar app.jar

PAUSE
EXIT