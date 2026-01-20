@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

REM ============================================================
REM Chatbot Éternel - MIA La Maison de l'IA
REM Script de démarrage Windows avec chemins dynamiques
REM ============================================================

title Chatbot Éternel - MIA

echo.
echo ============================================================
echo    Chatbot Éternel - MIA La Maison de l'IA
echo ============================================================
echo.

REM Obtenir le répertoire du script
set "SCRIPT_DIR=%~dp0"
set "PROJECT_DIR=%SCRIPT_DIR%.."
cd /d "%PROJECT_DIR%"

echo [INFO] Répertoire projet: %PROJECT_DIR%
echo.

REM ============================================================
REM Configuration du modèle
REM Ministral 3 14B - Modèle Mistral AI, excellent en français
REM Nécessite environ 10-12 Go de VRAM (GPU) ou 16+ Go RAM (CPU)
REM ============================================================
set "MODEL_NAME=mistralai/ministral-3-14b"
set "MODEL_SEARCH=ministral"

REM ============================================================
REM 1. Démarrer le serveur LM Studio
REM ============================================================
echo [1/5] Démarrage du serveur LM Studio...
lms server start

:wait_for_server
    lms ps >nul 2>&1
    if errorlevel 1 (
        echo       Attente du serveur LM Studio...
        timeout /t 2 /nobreak >nul
        goto wait_for_server
    )
echo [OK]  Serveur LM Studio prêt!
echo.

REM ============================================================
REM 2. Charger le modèle
REM ============================================================
echo [2/5] Chargement du modèle...
echo       Modèle: %MODEL_NAME%
lms load "%MODEL_NAME%"

:wait_for_model
    lms ps | findstr /I /C:"%MODEL_SEARCH%" >nul
    if errorlevel 1 (
        echo       Chargement en cours...
        timeout /t 3 /nobreak >nul
        goto wait_for_model
    )
echo [OK]  Modèle chargé!
echo.

REM ============================================================
REM 3. Trouver Python (venv_windows prioritaire)
REM ============================================================
echo [3/5] Recherche de Python...

REM Vérifier si venv_windows existe (créé par Installation Windows.bat)
if exist "%PROJECT_DIR%\venv_windows\Scripts\python.exe" (
    set "PYTHON_PATH=%PROJECT_DIR%\venv_windows\Scripts\python.exe"
    echo [OK]  Python trouve dans venv_windows
    goto python_found
)

REM Si pas de venv_windows, afficher une erreur
echo [ERREUR] L'environnement virtuel n'existe pas!
echo.
echo          Executez d'abord: "Installation Windows.bat"
echo          Ce script cree l'environnement Python necessaire.
echo.
pause
exit /b 1

:python_found
echo       Utilisation de: %PYTHON_PATH%
echo.

REM ============================================================
REM 4. Lancer le serveur Flask
REM ============================================================
echo [4/5] Démarrage du serveur Flask...
start "Chatbot Flask Server" /MIN cmd /c ""%PYTHON_PATH%" "%PROJECT_DIR%\ChatbotAI.py""

REM Attendre que Flask soit prêt
echo       Attente du serveur Flask...
:wait_for_flask
    curl --silent --output nul http://127.0.0.1:5000 >nul 2>&1
    if errorlevel 1 (
        timeout /t 2 /nobreak >nul
        goto wait_for_flask
    )
echo [OK]  Serveur Flask prêt sur http://localhost:5000
echo.

REM ============================================================
REM 5. Ouvrir le navigateur
REM ============================================================
echo [5/5] Ouverture du navigateur...

REM Essayer Chrome d'abord
if exist "C:\Program Files\Google\Chrome\Application\chrome.exe" (
    start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" "http://localhost:5000"
    timeout /t 2 /nobreak >nul
    REM Mettre en plein écran avec F11
    powershell -NoProfile -Command "(New-Object -ComObject WScript.Shell).SendKeys('{F11}')" >nul 2>&1
    goto browser_opened
)

REM Essayer Edge
if exist "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" (
    start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "http://localhost:5000"
    goto browser_opened
)

REM Navigateur par défaut
start "" "http://localhost:5000"

:browser_opened
echo [OK]  Navigateur ouvert!
echo.

REM ============================================================
REM Terminé
REM ============================================================
echo ============================================================
echo    Chatbot Éternel démarré avec succès!
echo    URL: http://localhost:5000
echo    Pour arrêter: Fermez cette fenêtre ou lancez stop.bat
echo ============================================================
echo.

REM Garder la fenêtre ouverte pour voir les logs
pause
