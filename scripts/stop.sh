#!/bin/bash
# ============================================================
# Chatbot Éternel 2025 - Script d'arrêt Linux
# Utilise LM Studio CLI (lms) si disponible
# ============================================================

echo "🛑 Arrêt de Chatbot Éternel..."

# 1. Arrêter le processus Python/Flask
echo ""
echo "🐍 Arrêt du serveur Flask..."
pkill -f "ChatbotAI.py" 2>/dev/null && echo "✅ Flask arrêté" || echo "ℹ️  Flask n'était pas en cours d'exécution"

# 2. Si lms est disponible, arrêter LM Studio
if command -v lms &> /dev/null; then
    # Décharger le modèle
    echo ""
    echo "📤 Déchargement du modèle..."
    lms unload --all 2>/dev/null && echo "✅ Modèle déchargé" || echo "ℹ️  Aucun modèle à décharger"

    # Arrêter le serveur LM Studio
    echo ""
    echo "🔧 Arrêt du serveur LM Studio..."
    lms server stop 2>/dev/null && echo "✅ Serveur LM Studio arrêté" || echo "ℹ️  Serveur n'était pas en cours d'exécution"
else
    echo ""
    echo "ℹ️  LM Studio CLI non trouvé - arrêtez LM Studio manuellement si nécessaire"
fi

echo ""
echo "============================================"
echo "✅ Chatbot Éternel arrêté proprement"
echo "============================================"
