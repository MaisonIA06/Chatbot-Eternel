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

echo [INFO] Répertoire projet: %PROJECT_DIR%
echo.

REM ============================================================
REM 1. Vérifier Python
REM ============================================================
echo [1/4] Vérification de Python...

where python >nul 2>&1
if errorlevel 1 (
    echo [ERREUR] Python n'est pas installé ou n'est pas dans le PATH!
    echo.
    echo          Téléchargez Python depuis: https://www.python.org/downloads/
    echo          Cochez "Add Python to PATH" lors de l'installation!
    echo.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo [OK]  %PYTHON_VERSION% trouvé
echo.

REM ============================================================
REM 2. Créer l'environnement virtuel Windows
REM ============================================================
echo [2/4] Création de l'environnement virtuel Windows...

if exist "%PROJECT_DIR%\venv_windows" (
    echo [INFO] Le venv Windows existe déjà, suppression...
    rmdir /s /q "%PROJECT_DIR%\venv_windows"
)

python -m venv "%PROJECT_DIR%\venv_windows"

if not exist "%PROJECT_DIR%\venv_windows\Scripts\python.exe" (
    echo [ERREUR] Échec de la création du venv!
    pause
    exit /b 1
)

echo [OK]  Environnement virtuel créé: venv_windows
echo.

REM ============================================================
REM 3. Installer les dépendances
REM ============================================================
echo [3/4] Installation des dépendances Python...

"%PROJECT_DIR%\venv_windows\Scripts\pip.exe" install --upgrade pip >nul 2>&1
"%PROJECT_DIR%\venv_windows\Scripts\pip.exe" install -r "%PROJECT_DIR%\requirements.txt"

if errorlevel 1 (
    echo [ERREUR] Échec de l'installation des dépendances!
    pause
    exit /b 1
)

echo.
echo [OK]  Dépendances installées!
echo.

REM ============================================================
REM 4. Vérifier LM Studio
REM ============================================================
echo [4/4] Vérification de LM Studio CLI...

where lms >nul 2>&1
if errorlevel 1 (
    echo [ATTENTION] LM Studio CLI (lms) n'est pas installé!
    echo.
    echo             Téléchargez LM Studio depuis: https://lmstudio.ai/
    echo             Puis activez le CLI dans les paramètres de LM Studio.
    echo.
) else (
    echo [OK]  LM Studio CLI trouvé!
)

echo.
echo ============================================================
echo    Installation terminée avec succès!
echo ============================================================
echo.
echo    Prochaines étapes:
echo    1. Lancez LM Studio
echo    2. Téléchargez le modèle: mistralai/ministral-3-14b
echo       (Recherchez "ministral" dans LM Studio)
echo    3. Exécutez "Chatbol Eternel.bat" pour démarrer le chatbot
echo.
echo    Note: Ce modèle nécessite ~10-12 Go VRAM ou 16+ Go RAM
echo.
echo ============================================================
echo.

pause
