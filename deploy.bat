@echo off
setlocal

REM === Configuration ===
set TOMCAT_HOME=C:\tomcat-10.1.28-windows-x64\apache-tomcat-10.1.28
set CATALINA_HOME=%TOMCAT_HOME%
set TOMCAT_DIR=%TOMCAT_HOME%\webapps
set WAR_FILE=target\biblio-1.war

echo ===============================================
echo 🚀 DEPLOIEMENT BIBLIOTHEQUE
echo ===============================================

REM === Vérification Tomcat ===
if not exist "%TOMCAT_HOME%" (
    echo  ERREUR : Dossier Tomcat non trouvé : %TOMCAT_HOME%
    pause
    exit /b 1
)

REM === Arrêt de Tomcat si en cours ===
echo ------------------------------
echo 🛑 Arrêt de Tomcat...
echo ------------------------------
call "%TOMCAT_HOME%\bin\shutdown.bat" >nul 2>&1
timeout /t 5 /nobreak >nul

REM === Nettoyage ===
echo ------------------------------
echo 🧹 Nettoyage des anciens déploiements...
echo ------------------------------
if exist "%TOMCAT_DIR%\biblio-1" (
    rmdir /s /q "%TOMCAT_DIR%\biblio-1"
    echo Dossier biblio-1 supprimé
)
if exist "%TOMCAT_DIR%\biblio-1.war" (
    del /f "%TOMCAT_DIR%\biblio-1.war"
    echo WAR biblio-1.war supprimé
)

REM === Compilation Maven ===
echo ------------------------------
echo 🔨 Compilation et packaging Maven...
echo ------------------------------
call mvn clean package -q

if errorlevel 1 (
    echo ❌ ERREUR : La compilation Maven a échoué.
    pause
    exit /b 1
)

REM === Vérification du WAR ===
if not exist "%WAR_FILE%" (
    echo ❌ ERREUR : Le fichier WAR n'a pas été généré : %WAR_FILE%
    pause
    exit /b 1
)

REM === Copie du WAR ===
echo ------------------------------
echo 📦 Déploiement du WAR...
echo ------------------------------
copy "%WAR_FILE%" "%TOMCAT_DIR%\"
if errorlevel 1 (
    echo ❌ ERREUR : Impossible de copier le WAR vers Tomcat
    pause
    exit /b 1
)
echo WAR copié avec succès

REM === Démarrage de Tomcat ===
echo ------------------------------
echo 🚀 Démarrage de Tomcat...
echo ------------------------------
call "%TOMCAT_HOME%\bin\startup.bat"

echo ------------------------------
echo DÉPLOIEMENT TERMINÉ !
echo ------------------------------
echo 🌐 Application disponible sur : http://localhost:8081/biblio-1
echo ⏱️ Attendre quelques secondes pour le démarrage complet...
echo ------------------------------

pause