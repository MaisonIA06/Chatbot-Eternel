@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

REM ============================================================
REM Chatbot Éternel - MIA La Maison de l'IA
REM Script d'arrêt Windows
REM ============================================================

title Arrêt Chatbot Éternel

echo.
echo ============================================================
echo    Arrêt de Chatbot Éternel - MIA
echo ============================================================
echo.

REM ============================================================
REM 1. Arrêter le serveur Flask (Python)
REM ============================================================
echo [1/3] Arrêt du serveur Flask...

:stop_python
    REM Chercher les processus Python exécutant ChatbotAI.py
    tasklist /FI "IMAGENAME eq python.exe" /FO CSV /V 2>nul | findstr /I "ChatbotAI.py" >nul
    if errorlevel 1 (
        echo [OK]  Serveur Flask arrêté.
    ) else (
        REM Terminer chaque processus correspondant
        for /F "tokens=2 delims=," %%G in ('tasklist /FI "IMAGENAME eq python.exe" /FO CSV /V ^| findstr /I "ChatbotAI.py"') do (
            echo       Arrêt du processus PID %%~G...
            taskkill /PID %%~G /F >nul 2>&1
        )
        timeout /t 1 /nobreak >nul
        goto stop_python
    )
echo.

REM ============================================================
REM 2. Décharger le modèle de LM Studio
REM ============================================================
echo [2/3] Déchargement du modèle LM Studio...

REM Vérifier si lms est disponible
where lms >nul 2>&1
if errorlevel 1 (
    echo [SKIP] LM Studio CLI non trouvé, passage à l'étape suivante.
    goto skip_unload
)

REM Essayer de décharger le modèle (peut échouer si pas de modèle chargé)
lms unload meta-llama-3.1-8b-instruct >nul 2>&1

:wait_for_unload
    lms ps 2>nul | findstr /I /C:"meta-llama" >nul 2>&1
    if not errorlevel 1 (
        echo       Attente du déchargement...
        timeout /t 2 /nobreak >nul
        goto wait_for_unload
    )
echo [OK]  Modèle déchargé.

:skip_unload
echo.

REM ============================================================
REM 3. Arrêter le serveur LM Studio
REM ============================================================
echo [3/3] Arrêt du serveur LM Studio...

where lms >nul 2>&1
if errorlevel 1 (
    echo [SKIP] LM Studio CLI non trouvé.
    goto done
)

lms server stop >nul 2>&1
echo [OK]  Serveur LM Studio arrêté.

:done
echo.
echo ============================================================
echo    Chatbot Éternel arrêté avec succès!
echo ============================================================
echo.

timeout /t 3
exit
