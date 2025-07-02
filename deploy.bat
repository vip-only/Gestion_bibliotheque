@echo off
setlocal

REM === Configuration ===
set TOMCAT_HOME=C:\tomcat-10.1.28-windows-x64\apache-tomcat-10.1.28
set CATALINA_HOME=%TOMCAT_HOME%
set TOMCAT_DIR=%TOMCAT_HOME%\webapps
set WAR_FILE=target\biblio-1.war

REM === Vérification Tomcat ===
if not exist "%TOMCAT_HOME%" (
    echo ERREUR : Dossier Tomcat non trouvé : %TOMCAT_HOME%
    pause
    exit /b 1
)

REM === Compilation Maven ===
echo ------------------------------
echo Compilation et packaging Maven...
echo ------------------------------
call mvn clean package

if errorlevel 1 (
    echo ERREUR : La compilation Maven a échoué.
    pause
    exit /b 1
)

REM === Vérification du WAR ===
if not exist "%WAR_FILE%" (
    echo ERREUR : Fichier WAR non trouvé : %WAR_FILE%
    pause
    exit /b 1
)

REM === Copie du WAR ===
echo ------------------------------
echo Copie du WAR vers Tomcat...
echo ------------------------------
copy /Y "%WAR_FILE%" "%TOMCAT_DIR%\"

if errorlevel 1 (
    echo ERREUR : La copie du WAR vers Tomcat a échoué.
    pause
    exit /b 1
)

REM === Redémarrage Tomcat ===
echo ------------------------------
echo Redémarrage de Tomcat...
echo ------------------------------


pause