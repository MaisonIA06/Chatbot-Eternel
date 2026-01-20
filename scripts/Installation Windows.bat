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
REM 1. Rechercher Python dans les emplacements courants
REM ============================================================
echo [1/4] Recherche de Python...
echo.

set "PYTHON_PATH="

REM Essayer py launcher (installé avec Python officiel)
where py >nul 2>&1
if not errorlevel 1 (
    set "PYTHON_PATH=py -3"
    echo [OK]  Python Launcher (py) trouvé
    goto python_found
)

REM Essayer python3
where python3 >nul 2>&1
if not errorlevel 1 (
    REM Vérifier que ce n'est pas l'alias Microsoft Store
    python3 --version >nul 2>&1
    if not errorlevel 1 (
        set "PYTHON_PATH=python3"
        echo [OK]  python3 trouvé
        goto python_found
    )
)

REM Essayer les chemins d'installation Python courants
for %%V in (313 312 311 310 39) do (
    if exist "%LOCALAPPDATA%\Programs\Python\Python%%V\python.exe" (
        set "PYTHON_PATH=%LOCALAPPDATA%\Programs\Python\Python%%V\python.exe"
        echo [OK]  Python trouvé: Python%%V
        goto python_found
    )
)

REM Essayer Program Files
for %%V in (313 312 311 310 39) do (
    if exist "C:\Python%%V\python.exe" (
        set "PYTHON_PATH=C:\Python%%V\python.exe"
        echo [OK]  Python trouvé: C:\Python%%V
        goto python_found
    )
)

REM Essayer Anaconda
if exist "C:\ProgramData\anaconda3\python.exe" (
    set "PYTHON_PATH=C:\ProgramData\anaconda3\python.exe"
    echo [OK]  Python trouvé dans Anaconda (ProgramData)
    goto python_found
)

if exist "%USERPROFILE%\anaconda3\python.exe" (
    set "PYTHON_PATH=%USERPROFILE%\anaconda3\python.exe"
    echo [OK]  Python trouvé dans Anaconda (User)
    goto python_found
)

if exist "%USERPROFILE%\miniconda3\python.exe" (
    set "PYTHON_PATH=%USERPROFILE%\miniconda3\python.exe"
    echo [OK]  Python trouvé dans Miniconda
    goto python_found
)

REM Python non trouvé
echo [ERREUR] Python n'est pas installe ou n'est pas dans le PATH!
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
echo       [x] "Install for all users" (recommande)
echo.
echo    3. Cliquez sur "Install Now"
echo.
echo    4. Relancez ce script apres l'installation
echo.
echo ============================================================
echo.
echo    ASTUCE: Si Python est deja installe mais non detecte,
echo    desactivez les alias Microsoft Store:
echo    Parametres ^> Applications ^> Alias d'execution d'application
echo    ^> Desactivez "python.exe" et "python3.exe"
echo.
echo ============================================================
echo.
pause
exit /b 1

:python_found
echo       Utilisation de: %PYTHON_PATH%

REM Vérifier la version
echo.
echo [INFO] Version de Python:
%PYTHON_PATH% --version
echo.

REM ============================================================
REM 2. Créer l'environnement virtuel Windows
REM ============================================================
echo [2/4] Creation de l'environnement virtuel Windows...

if exist "%PROJECT_DIR%\venv_windows" (
    echo [INFO] Le venv Windows existe deja, suppression...
    rmdir /s /q "%PROJECT_DIR%\venv_windows"
)

%PYTHON_PATH% -m venv "%PROJECT_DIR%\venv_windows"

if not exist "%PROJECT_DIR%\venv_windows\Scripts\python.exe" (
    echo [ERREUR] Echec de la creation du venv!
    echo.
    echo          Essayez de reinstaller Python avec les options:
    echo          [x] "Add Python to PATH"
    echo          [x] "Install pip"
    echo          [x] "Install for all users"
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
"%PROJECT_DIR%\venv_windows\Scripts\pip.exe" install -r "%PROJECT_DIR%\requirements.txt"

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
    echo             3. Allez dans Settings ^> Developer
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
echo    Prochaines etapes:
echo    1. Lancez LM Studio
echo    2. Telechargez le modele: mistralai/ministral-3-14b
echo       (Recherchez "ministral" dans LM Studio)
echo    3. Executez "Chatbol Eternel.bat" pour demarrer le chatbot
echo.
echo    Note: Ce modele necessite ~10-12 Go VRAM ou 16+ Go RAM
echo.
echo ============================================================
echo.

pause
