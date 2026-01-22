"""
Chatbot Éternel - MIA La Maison de l'IA
Serveur Flask avec intégration LM Studio
Thème : Grandes figures de l'histoire de la médecine et des sciences
"""

from flask import Flask, render_template, request, jsonify, session
from openai import OpenAI
import requests
import os
import secrets

app = Flask(__name__)

# Clé secrète pour les sessions Flask (générée automatiquement)
app.secret_key = os.environ.get('FLASK_SECRET_KEY', secrets.token_hex(32))

# ============================================================
# CONFIGURATION - Modifiez ces valeurs selon votre setup
# ============================================================
LM_STUDIO_URL = os.environ.get('LM_STUDIO_URL', "http://localhost:1234/v1")
LM_STUDIO_API_KEY = os.environ.get('LM_STUDIO_API_KEY', "lm-studio")

# Nom du modèle chargé dans LM Studio
# Mistral 7B Instruct v0.2 - Excellent en français, rapide sur RTX 3060
MODEL_NAME = os.environ.get('MODEL_NAME', "mistral-7b-instruct-v0.2")

# Température de génération (0.0 = déterministe, 1.0 = créatif)
TEMPERATURE = float(os.environ.get('TEMPERATURE', '0.2'))

# Nombre maximum de tokens par réponse (limite la longueur des messages)
MAX_TOKENS = int(os.environ.get('MAX_TOKENS', '100'))

# Nombre maximum de messages dans l'historique (pour limiter les tokens)
MAX_HISTORY_LENGTH = int(os.environ.get('MAX_HISTORY_LENGTH', '10'))

# Mode debug (désactiver en production)
DEBUG_MODE = os.environ.get('FLASK_DEBUG', 'false').lower() == 'true'

# ============================================================
# PERSONNAGES - Grandes figures de la médecine et des sciences
# ============================================================

ROLES_GROUP_1 = {
    "Hildegarde de Bingen": """tu es Hildegarde de Bingen, abbesse bénédictine allemande du XIIe siècle (1098-1179), 
        visionnaire, compositrice, naturaliste et médecin. Tu as écrit le "Liber Subtilitatum" sur les propriétés 
        curatives des plantes, pierres et animaux. Tu crois en l'harmonie entre le corps, l'âme et le cosmos. 
        Tu parles avec sagesse mystique, citant parfois tes visions divines. Tu utilises les termes "viriditas" 
        (force vitale verte) et "humeurs". Tu fais des réponses courtes et profondes.""",
    
    "Florence Nightingale": """tu es Florence Nightingale, infirmière britannique (1820-1910), pionnière des 
        soins infirmiers modernes. Tu as révolutionné l'hygiène hospitalière pendant la guerre de Crimée, 
        réduisant drastiquement la mortalité. Tu es aussi statisticienne et as inventé le diagramme polaire. 
        Tu parles avec détermination et compassion, insistant sur l'importance de l'hygiène, de l'air frais, 
        de la lumière et de la nutrition. Tu cites parfois tes "Notes on Nursing". Tu fais des réponses courtes.""",
    
    "Marie Curie": """tu es Marie Curie, physicienne et chimiste franco-polonaise (1867-1934). Née Maria 
        Skłodowska à Varsovie, tu as découvert le polonium et le radium avec ton mari Pierre. Tu es la 
        première femme Prix Nobel et la seule personne à avoir reçu deux Prix Nobel dans deux sciences 
        différentes (physique 1903, chimie 1911). Tu parles avec passion de la science, humilité et 
        détermination. Tu évoques parfois Pierre et tes filles Irène et Ève. Tu fais des réponses courtes.""",
    
    "Rosalind Franklin": """tu es Rosalind Franklin, chimiste et cristallographe britannique (1920-1958). 
        Tes travaux de diffraction aux rayons X, notamment la célèbre "Photo 51", ont été essentiels pour 
        découvrir la structure en double hélice de l'ADN. Tu es rigoureuse, perfectionniste et passionnée 
        par la science expérimentale. Tu parles avec précision scientifique et un certain agacement quand 
        on minimise ton travail. Tu mentionnes parfois ton travail sur les virus. Tu fais des réponses courtes.""",
}

ROLES_GROUP_2 = {
    "Hippocrate": """tu es Hippocrate de Cos, médecin grec de l'Antiquité (vers 460-370 av. J.-C.), 
        considéré comme le père de la médecine. Tu as fondé l'école de médecine de Cos et établi la 
        médecine comme discipline rationnelle, séparée de la religion. Tu crois en la théorie des quatre 
        humeurs (sang, phlegme, bile jaune, bile noire). Tu parles avec sagesse et éthique, citant parfois 
        ton serment. "Primum non nocere" - d'abord ne pas nuire. Tu fais des réponses courtes et sages.""",
    
    "Avicenne": """tu es Ibn Sina, appelé Avicenne en Occident, médecin et philosophe persan (980-1037). 
        Tu as écrit le "Canon de la médecine", ouvrage de référence pendant des siècles en Europe et dans 
        le monde islamique. Tu maîtrises la philosophie d'Aristote, l'astronomie, les mathématiques et la 
        poésie. Tu parles avec érudition, mêlant médecine et philosophie. Tu évoques parfois Galien, 
        Aristote ou tes voyages à travers la Perse. Tu fais des réponses courtes et savantes.""",
    
    "Louis Pasteur": """tu es Louis Pasteur, chimiste et physicien français (1822-1895), pionnier de la 
        microbiologie. Tu as découvert les principes de la vaccination, de la pasteurisation et réfuté 
        la génération spontanée. Tu as sauvé l'industrie de la soie et créé le vaccin contre la rage. 
        Tu parles avec passion et conviction scientifique. Tu cites parfois "Le hasard ne favorise que 
        les esprits préparés". Tu mentionnes ton laboratoire et tes expériences. Tu fais des réponses courtes.""",
    
    "Alexander Fleming": """tu es Alexander Fleming, médecin et biologiste écossais (1881-1955), 
        découvreur de la pénicilline en 1928, Prix Nobel de médecine 1945. Cette découverte accidentelle 
        d'une moisissure qui tue les bactéries a révolutionné la médecine. Tu parles avec humour britannique 
        et modestie, rappelant que "la chance favorise l'esprit préparé". Tu évoques parfois St Mary's Hospital 
        à Londres ou tes collègues Florey et Chain. Tu fais des réponses courtes et pragmatiques.""",
}

# Personnages par défaut
DEFAULT_ROLE1 = "Marie Curie"
DEFAULT_ROLE2 = "Louis Pasteur"


def check_lm_studio_connection():
    """Vérifie que LM Studio est accessible"""
    try:
        response = requests.get(f"{LM_STUDIO_URL}/models", timeout=5)
        if response.status_code == 200:
            print("✅ Connexion LM Studio OK")
            return True
    except requests.exceptions.ConnectionError:
        print(f"❌ ERREUR: LM Studio n'est pas accessible sur {LM_STUDIO_URL}")
        print("   → Lancez LM Studio avec: lms server start")
        return False
    except Exception as e:
        print(f"❌ ERREUR: {e}")
        return False
    return False


# Client OpenAI pointant vers LM Studio
client = OpenAI(base_url=LM_STUDIO_URL, api_key=LM_STUDIO_API_KEY)


def build_system_prompt(consigne):
    """Construit le prompt système pour le personnage"""
    return (
        f"Tu es {consigne} Tu réponds UNIQUEMENT en français, en 1ère personne. "
        f"Ne dis jamais que tu es un modèle de langage ou une IA, reste absolument dans ton rôle historique. "
        f"Tu parleras de médecine, de science, de tes découvertes, de ton époque, de philosophie et de la vie. "
        f"Tu poseras des questions à ton interlocuteur sur ses propres travaux et découvertes. "
        f"Tu peux partager des anecdotes de ta vie, évoquer tes collègues, tes défis et tes réussites. "
        f"Les échanges peuvent être amicaux, passionnés, ou même comporter des désaccords scientifiques ou philosophiques. "
        f"Tu fais des réponses TRÈS courtes d'une seule phrase, maximum 15 mots. "
        f"Ne signe JAMAIS tes messages, ne mets pas ton nom à la fin."
    )


def get_session_data():
    """Récupère ou initialise les données de session"""
    if 'role1' not in session:
        session['role1'] = DEFAULT_ROLE1
        session['consigne1'] = ROLES_GROUP_1[DEFAULT_ROLE1]
    if 'role2' not in session:
        session['role2'] = DEFAULT_ROLE2
        session['consigne2'] = ROLES_GROUP_2[DEFAULT_ROLE2]
    if 'conversation_history' not in session:
        session['conversation_history'] = []
    
    return {
        'role1': session['role1'],
        'role2': session['role2'],
        'consigne1': session['consigne1'],
        'consigne2': session['consigne2'],
        'conversation_history': session['conversation_history']
    }


def generate_response(message, consigne, speaker_role):
    """Génère une réponse via LM Studio avec gestion d'erreurs et historique"""
    data = get_session_data()
    conversation_history = data['conversation_history']
    
    print(f"🎭 Personnage: {speaker_role}")
    print(f"📝 Historique: {len(conversation_history)} messages")
    
    # Construire les messages (sans rôle "system" car non supporté par certains modèles)
    messages = []
    
    # Ajouter l'historique (limité aux N derniers messages)
    messages.extend(conversation_history[-MAX_HISTORY_LENGTH:])
    
    # Construire le message utilisateur avec les instructions du personnage intégrées
    system_instructions = build_system_prompt(consigne)
    if message:
        # Intégrer les instructions dans le message utilisateur
        full_message = f"[Instructions: {system_instructions}]\n\nMessage de ton interlocuteur: {message}"
        messages.append({"role": "user", "content": full_message})
    else:
        # Premier message - juste les instructions pour démarrer
        messages.append({"role": "user", "content": f"[Instructions: {system_instructions}]\n\nCommence la conversation en te présentant brièvement."})
    
    try:
        completion = client.chat.completions.create(
            model=MODEL_NAME,
            messages=messages,
            temperature=TEMPERATURE,
            max_tokens=MAX_TOKENS,
        )
        response = completion.choices[0].message.content
        
        # Ajouter à l'historique de session
        if message:
            conversation_history.append({"role": "user", "content": message})
        conversation_history.append({"role": "assistant", "content": response})
        
        # Limiter la taille de l'historique
        if len(conversation_history) > MAX_HISTORY_LENGTH * 2:
            conversation_history = conversation_history[-MAX_HISTORY_LENGTH:]
        
        # Sauvegarder dans la session
        session['conversation_history'] = conversation_history
        session.modified = True
        
        return response
        
    except Exception as e:
        error_msg = f"Erreur de génération: {str(e)}"
        print(f"❌ {error_msg}")
        return "[Erreur: LM Studio ne répond pas. Vérifiez que le serveur est lancé.]"


@app.route("/")
def home():
    """Page d'accueil avec le chatbot"""
    data = get_session_data()
    return render_template("index.html", role1=data['role1'], role2=data['role2'])


@app.route("/update_characters", methods=["POST"])
def update_characters():
    """Met à jour les personnages sélectionnés"""
    role1 = request.form.get("role1", DEFAULT_ROLE1)
    role2 = request.form.get("role2", DEFAULT_ROLE2)
    
    # Valider les rôles
    if role1 not in ROLES_GROUP_1:
        role1 = DEFAULT_ROLE1
    if role2 not in ROLES_GROUP_2:
        role2 = DEFAULT_ROLE2
    
    # Mettre à jour la session
    session['role1'] = role1
    session['role2'] = role2
    session['consigne1'] = ROLES_GROUP_1[role1]
    session['consigne2'] = ROLES_GROUP_2[role2]
    session['conversation_history'] = []  # Réinitialiser l'historique
    session.modified = True
    
    print(f"🔄 Nouvelle conversation: {role1} ↔ {role2}")

    return jsonify({
        "role1": role1,
        "role2": role2,
        "consigne1": session['consigne1'],
        "consigne2": session['consigne2']
    })


@app.route("/get_response", methods=["POST"])
def get_response():
    """Génère une réponse du personnage"""
    message = request.form.get("message", "")
    role = request.form.get("role", "")
    
    data = get_session_data()
    
    # Déterminer qui doit répondre
    if role == data['role2']:
        new_role = data['role1']
        new_consigne = data['consigne1']
    else:
        new_role = data['role2']
        new_consigne = data['consigne2']
    
    response = generate_response(message, new_consigne, new_role)
    
    return jsonify({
        "response": response,
        "role": new_role
    })


@app.route("/health")
def health_check():
    """Endpoint de vérification de l'état du serveur"""
    lm_studio_ok = check_lm_studio_connection()
    return jsonify({
        "status": "ok",
        "lm_studio_connected": lm_studio_ok,
        "model": MODEL_NAME
    })


if __name__ == "__main__":
    print("=" * 60)
    print("🏥 Chatbot Éternel - MIA La Maison de l'IA")
    print("   Thème : Grandes figures de la médecine")
    print("=" * 60)
    
    # Vérifier la connexion LM Studio au démarrage
    if not check_lm_studio_connection():
        print("\n⚠️  Démarrage sans LM Studio - les réponses seront en erreur")
        print("   Pour démarrer LM Studio: lms server start && lms load <modèle>\n")
    
    print(f"\n📊 Configuration:")
    print(f"   • Modèle: {MODEL_NAME}")
    print(f"   • Température: {TEMPERATURE}")
    print(f"   • Max tokens: {MAX_TOKENS}")
    print(f"   • Historique max: {MAX_HISTORY_LENGTH} messages")
    print(f"   • Mode debug: {DEBUG_MODE}")
    print(f"\n👥 Personnages disponibles:")
    print(f"   Groupe 1: {', '.join(ROLES_GROUP_1.keys())}")
    print(f"   Groupe 2: {', '.join(ROLES_GROUP_2.keys())}")
    print(f"\n🌐 Serveur: http://localhost:5000")
    print("=" * 60 + "\n")
    
    app.run(debug=DEBUG_MODE, host='0.0.0.0', port=5000)
