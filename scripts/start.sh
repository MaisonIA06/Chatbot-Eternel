#!/bin/bash
# ============================================================
# Chatbot Éternel 2025 - Script de démarrage Linux
# Utilise LM Studio CLI (lms) si disponible, sinon mode manuel
# ============================================================

set -e

# Configuration - Modèle à charger dans LM Studio
# Mistral 7B Instruct v0.2 - Excellent en français, rapide
# Nécessite environ 6-8 Go de VRAM (GPU)
MODEL="mistralai/Mistral-7B-Instruct-v0.2-GGUF"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
VENV_DIR="$PROJECT_DIR/venv"

echo "🚀 Démarrage de Chatbot Éternel..."
echo "📂 Répertoire projet: $PROJECT_DIR"

# 0. Activer l'environnement virtuel Python
if [ -d "$VENV_DIR" ]; then
    echo ""
    echo "🐍 Activation de l'environnement virtuel..."
    source "$VENV_DIR/bin/activate"
    echo "✅ Venv activé: $(which python)"
else
    echo "❌ ERREUR: Environnement virtuel non trouvé dans $VENV_DIR"
    echo "   Créez-le avec: python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt"
    exit 1
fi

# 1. Vérifier si lms (LM Studio CLI) est disponible
if command -v lms &> /dev/null; then
    echo ""
    echo "🔧 Démarrage du serveur LM Studio..."
    lms server start

    # 2. Attendre que le serveur soit prêt
    echo "⏳ Attente du serveur LM Studio..."
    while ! lms ps > /dev/null 2>&1; do
        echo "   En attente..."
        sleep 1
    done
    echo "✅ Serveur LM Studio prêt!"

    # 3. Charger le modèle
    echo ""
    echo "📥 Chargement du modèle..."
    echo "   Modèle: $MODEL"
    lms load "$MODEL"

    # 4. Attendre que le modèle soit chargé
    echo "⏳ Attente du chargement du modèle..."
    while ! lms ps | grep -qi "mistral-7b"; do
        echo "   Chargement en cours..."
        sleep 2
    done
    echo "✅ Modèle chargé!"
else
    echo ""
    echo "⚠️  LM Studio CLI (lms) non trouvé"
    echo "   → Mode manuel: lancez LM Studio vous-même sur localhost:1234"
    echo ""
    echo "   Pour installer lms:"
    echo "   curl -fsSL https://lmstudio.ai/install.sh | bash"
    echo ""
fi

# 5. Lancer le serveur Flask
echo ""
echo "🐍 Lancement du serveur Flask..."
cd "$PROJECT_DIR"
python ChatbotAI.py &
FLASK_PID=$!
echo "   PID Flask: $FLASK_PID"

# 6. Attendre que Flask soit prêt
echo "⏳ Attente du serveur Flask..."
while ! curl --silent --output /dev/null http://127.0.0.1:5000; do
    sleep 1
done
echo "✅ Serveur Flask prêt!"

# 7. Ouvrir le navigateur
echo ""
echo "🌐 Ouverture du navigateur..."
if command -v xdg-open > /dev/null; then
    xdg-open "http://localhost:5000" &
elif command -v firefox > /dev/null; then
    firefox "http://localhost:5000" &
elif command -v chromium > /dev/null; then
    chromium "http://localhost:5000" &
else
    echo "⚠️  Ouvre manuellement: http://localhost:5000"
fi

echo ""
echo "============================================"
echo "✅ Chatbot Éternel démarré avec succès!"
echo "   URL: http://localhost:5000"
echo "   Pour arrêter: ./stop.sh"
echo "============================================"

# Garder le script actif
wait $FLASK_PID
