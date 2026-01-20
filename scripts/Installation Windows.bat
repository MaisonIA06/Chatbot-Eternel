@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

REM ============================================================
REM Chatbot Éternel - Installation Windows
REM Ce script crée l'environnement virtuel et installe les dépendances
REM À exécuter UNE SEULE FOIS avant la première utilisation
REM ============================================================

title Installation Chatbot Éternel

echo.
echo ============================================================
echo    Installation de Chatbot Éternel - MIA
echo ============================================================
echo.

REM Obtenir le répertoire du projet
set "SCRIPT_DIR=%~dp0"
set "PROJECT_DIR=%SCRIPT_DIR%.."
cd /d "%PROJECT_DIR%"

echo [INFO] Repertoire projet: %PROJECT_DIR%
echo.

REM ============================================================
REM 1. Rechercher Python avec py (Python Launcher)
REM ============================================================
echo [1/4] Recherche de Python...
echo.

REM Le Python Launcher (py) est la méthode la plus fiable sur Windows
py -3 --version >nul 2>&1
if not errorlevel 1 (
    echo [OK]  Python Launcher (py) trouve!
    py -3 --version
    echo.
    goto create_venv
)

REM Si py ne fonctionne pas, essayer python
python --version >nul 2>&1
if not errorlevel 1 (
    echo [OK]  Python trouve!
    python --version
    echo.
    set "USE_PYTHON_CMD=1"
    goto create_venv
)

REM Python non trouvé
echo [ERREUR] Python n'est pas installe!
echo.
echo ============================================================
echo    INSTRUCTIONS D'INSTALLATION DE PYTHON
echo ============================================================
echo.
echo    1. Telechargez Python depuis:
echo       https://www.python.org/downloads/
echo.
echo    2. Lancez l'installateur et COCHEZ:
echo       [x] "Add Python to PATH"  (TRES IMPORTANT!)
echo.
echo    3. Cliquez sur "Install Now"
echo.
echo    4. Redemarrez votre PC
echo.
echo    5. Relancez ce script
echo.
echo ============================================================
echo.
pause
exit /b 1

:create_venv
REM ============================================================
REM 2. Créer l'environnement virtuel Windows
REM ============================================================
echo [2/4] Creation de l'environnement virtuel Windows...

if exist "%PROJECT_DIR%\venv_windows" (
    echo [INFO] Le venv Windows existe deja, suppression...
    rmdir /s /q "%PROJECT_DIR%\venv_windows" >nul 2>&1
)

REM Créer le venv avec py -3
if defined USE_PYTHON_CMD (
    python -m venv "%PROJECT_DIR%\venv_windows"
) else (
    py -3 -m venv "%PROJECT_DIR%\venv_windows"
)

if not exist "%PROJECT_DIR%\venv_windows\Scripts\python.exe" (
    echo [ERREUR] Echec de la creation du venv!
    echo.
    pause
    exit /b 1
)

echo [OK]  Environnement virtuel cree: venv_windows
echo.

REM ============================================================
REM 3. Installer les dépendances
REM ============================================================
echo [3/4] Installation des dependances Python...
echo.

echo       Mise a jour de pip...
"%PROJECT_DIR%\venv_windows\Scripts\python.exe" -m pip install --upgrade pip >nul 2>&1

echo       Installation de Flask, OpenAI, Requests...
"%PROJECT_DIR%\venv_windows\Scripts\pip.exe" install flask openai requests

if errorlevel 1 (
    echo.
    echo [ERREUR] Echec de l'installation des dependances!
    echo          Verifiez votre connexion internet.
    pause
    exit /b 1
)

echo.
echo [OK]  Dependances installees!
echo.

REM ============================================================
REM 4. Vérifier LM Studio
REM ============================================================
echo [4/4] Verification de LM Studio CLI...

where lms >nul 2>&1
if errorlevel 1 (
    echo [ATTENTION] LM Studio CLI (lms) n'est pas detecte!
    echo.
    echo             1. Telechargez LM Studio: https://lmstudio.ai/
    echo             2. Installez-le et lancez-le
    echo             3. Allez dans Settings - Developer
    echo             4. Activez "Enable CLI" et cliquez "Apply"
    echo             5. Redemarrez votre terminal
    echo.
) else (
    echo [OK]  LM Studio CLI trouve!
)

echo.
echo ============================================================
echo    Installation terminee avec succes!
echo ============================================================
echo.
echo    IMPORTANT - Si vous utilisez PowerShell:
echo    -----------------------------------------
echo    Si l'activation du venv echoue, ouvrez PowerShell
echo    en tant qu'administrateur et executez:
echo.
echo    Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
echo.
echo    Puis repondez "O" (Oui) a la question.
echo.
echo ============================================================
echo.
echo    Prochaines etapes:
echo    1. Lancez LM Studio
echo    2. Telechargez le modele: Mistral-7B-Instruct-v0.2-GGUF
echo       (Recherchez "mistral 7b instruct" dans LM Studio)
echo    3. Executez "Chatbol Eternel.bat" pour demarrer le chatbot
echo.
echo    Note: Ce modele necessite ~6-8 Go VRAM
echo.
echo ============================================================
echo.

pause
