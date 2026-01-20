# Chatbot Éternel - MIA La Maison de l'IA

**Dialogues fictifs entre grandes figures de l'histoire de la médecine**

Un chatbot interactif qui simule des conversations entre personnages historiques célèbres du monde médical et scientifique, propulsé par l'IA locale via LM Studio.

![Python](https://img.shields.io/badge/Python-3.10+-blue.svg)
![Flask](https://img.shields.io/badge/Flask-3.x-green.svg)
![LM Studio](https://img.shields.io/badge/LM%20Studio-Compatible-purple.svg)
![License](https://img.shields.io/badge/License-Propriétaire-red.svg)

---

## Table des matières

- [Présentation](#présentation)
- [Personnages](#personnages)
- [Prérequis](#prérequis)
- [Installation Windows](#installation-windows)
- [Installation Linux](#installation-linux)
- [Utilisation](#utilisation)
- [Configuration](#configuration)
- [Architecture](#architecture)
- [Crédits](#crédits)

---

## Présentation

**Chatbot Éternel** est une application web qui génère des dialogues fictifs et automatiques entre deux personnages historiques de la médecine. L'IA joue alternativement chaque rôle, créant des échanges fascinants sur la science, la médecine, la philosophie et la vie.

### Fonctionnalités

- **8 personnages historiques** avec des personnalités distinctes
- **IA locale** via LM Studio (pas de données envoyées sur internet)
- **Dialogues automatiques** qui s'enchaînent naturellement
- **Interface moderne** avec thème sombre élégant
- **Design responsive** (desktop, tablette, mobile)
- **Scripts automatisés** pour Windows et Linux

---

## Personnages

### Pionnières (Groupe 1)

| Personnage | Époque | Spécialité |
|------------|--------|------------|
| **Hildegarde de Bingen** | 1098-1179 | Médecine naturelle, mysticisme |
| **Florence Nightingale** | 1820-1910 | Soins infirmiers, hygiène |
| **Marie Curie** | 1867-1934 | Radioactivité, physique |
| **Rosalind Franklin** | 1920-1958 | Cristallographie, ADN |

### Pionniers (Groupe 2)

| Personnage | Époque | Spécialité |
|------------|--------|------------|
| **Hippocrate** | ~460-370 av. J.-C. | Médecine rationnelle |
| **Avicenne** | 980-1037 | Médecine islamique, philosophie |
| **Louis Pasteur** | 1822-1895 | Microbiologie, vaccination |
| **Alexander Fleming** | 1881-1955 | Pénicilline, antibiotiques |

---

## Prérequis

### Logiciels requis

- **Python 3.10** ou supérieur
- **LM Studio** avec le CLI activé
- **Navigateur web** moderne (Chrome, Edge, Firefox)

### Modèle IA recommandé

```
Mistral-7B-Instruct-v0.2-GGUF
```

| Configuration | RAM/VRAM requise |
|---------------|------------------|
| GPU (recommandé) | ~6-8 Go VRAM |
| CPU only | ~10-12 Go RAM |

---

## Installation Windows

### Étape 1 : Installer les prérequis

1. **Python** : [python.org/downloads](https://www.python.org/downloads/)
   - Cocher **"Add Python to PATH"** lors de l'installation

2. **LM Studio** : [lmstudio.ai](https://lmstudio.ai/)
   - Après installation, activer le CLI dans Settings > Developer

### Étape 2 : Télécharger le modèle

1. Ouvrir LM Studio
2. Aller dans "Discover" ou "Search"
3. Rechercher **"mistral 7b instruct"**
4. Télécharger `Mistral-7B-Instruct-v0.2` (version Q4_K_M ou Q5_K_M recommandée)

### Étape 3 : Autoriser les scripts PowerShell (si nécessaire)

Si vous utilisez PowerShell, ouvrez-le **en tant qu'administrateur** et exécutez :

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

Répondez **"O"** (Oui) à la question.

### Étape 4 : Installer le projet

```batch
# Double-cliquer sur :
scripts\Installation Windows.bat
```

Ce script crée automatiquement l'environnement virtuel `venv_windows` et installe les dépendances.

### Étape 5 : Lancer le chatbot

```batch
# Double-cliquer sur :
scripts\Chatbol Eternel.bat
```

Le navigateur s'ouvre automatiquement sur `http://localhost:5000`

### Arrêter le chatbot

```batch
# Double-cliquer sur :
scripts\Stop Chatbot Eternel.bat
```

---

## Installation Linux

### Étape 1 : Installer les prérequis

```bash
# Python et pip
sudo apt update
sudo apt install python3 python3-pip python3-venv

# LM Studio CLI
curl -fsSL https://lmstudio.ai/install.sh | bash
```

### Étape 2 : Créer l'environnement virtuel

```bash
cd "chatbot eternel"
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Étape 3 : Lancer le chatbot

```bash
./scripts/start.sh
```

### Arrêter le chatbot

```bash
./scripts/stop.sh
```

---

## Utilisation

1. **Sélectionner les personnages** en cliquant sur leurs portraits dans les panneaux latéraux
2. **Observer le dialogue** qui se génère automatiquement
3. **Changer de personnages** à tout moment pour démarrer une nouvelle conversation

### Interface

```
┌─────────────────────────────────────────────────────────┐
│  [Pionnières]     CHATBOT ÉTERNEL        [Pionniers]    │
│                                                         │
│  Hildegarde    ┌─────────────────────┐    Hippocrate    │
│  Nightingale   │  Marie Curie:       │    Avicenne      │
│  Marie Curie   │  "Bonjour Louis!"   │    Pasteur       │
│  Franklin      │                     │    Fleming       │
│                │  Louis Pasteur:     │                  │
│                │  "Chère Marie!"     │                  │
│                └─────────────────────┘                  │
└─────────────────────────────────────────────────────────┘
```

---

## Configuration

### Paramètres principaux (ChatbotAI.py)

| Paramètre | Valeur par défaut | Description |
|-----------|-------------------|-------------|
| `MODEL_NAME` | `mistral-7b-instruct-v0.2` | Modèle LM Studio |
| `TEMPERATURE` | `0.2` | Créativité (0.0 = déterministe, 1.0 = créatif) |
| `MAX_TOKENS` | `100` | Longueur max des réponses (~2-3 phrases) |
| `MAX_HISTORY_LENGTH` | `10` | Mémoire de conversation |

### Délai entre les messages (index.html)

| Paramètre | Valeur par défaut | Description |
|-----------|-------------------|-------------|
| `MESSAGE_DELAY` | `5000` | 5 secondes entre chaque message |

### Variables d'environnement (optionnel)

```bash
# URL du serveur LM Studio
export LM_STUDIO_URL="http://localhost:1234/v1"

# Nom du modèle
export MODEL_NAME="mistral-7b-instruct-v0.2"

# Température (0.0 = déterministe, 1.0 = créatif)
export TEMPERATURE="0.2"

# Longueur max des réponses
export MAX_TOKENS="100"

# Taille de l'historique de conversation
export MAX_HISTORY_LENGTH="10"

# Mode debug
export FLASK_DEBUG="false"
```

---

## Architecture

```
chatbot eternel/
├── ChatbotAI.py           # Serveur Flask principal
├── requirements.txt       # Dépendances Python
├── README.md              # Ce fichier
├── .gitignore             # Fichiers à ignorer
│
├── templates/
│   └── index.html         # Interface web
│
├── static/
│   ├── style.css          # Styles CSS (dark theme MIA)
│   ├── logo_mia.png       # Logo MIA
│   ├── MIA_Assets13.jpg   # Image de fond
│   └── *.png/jpg/webp     # Portraits des personnages
│
├── venv_windows/          # Environnement virtuel Windows (créé par le script)
│
└── scripts/
    ├── Installation Windows.bat   # Installation Windows
    ├── Chatbol Eternel.bat        # Démarrage Windows
    ├── Stop Chatbot Eternel.bat   # Arrêt Windows
    ├── start.sh                   # Démarrage Linux
    └── stop.sh                    # Arrêt Linux
```

### Stack technique

| Composant | Technologie |
|-----------|-------------|
| Backend | Python 3 + Flask |
| Frontend | HTML5 + CSS3 + JavaScript |
| IA | LM Studio (API compatible OpenAI) |
| Modèle | Mistral 7B Instruct v0.2 (Mistral AI) |

---

## Avertissement

> **Les dialogues générés par ce chatbot sont entièrement fictifs.**
> Les propos attribués aux personnages ne reflètent en aucun cas leurs opinions réelles, ni celles de La Maison de l'IA ou de ses agents.
> Ce projet a un but exclusivement ludique et éducatif.

---

## Crédits

### Développement

- **MIA - La Maison de l'IA**

### Technologies

- [Flask](https://flask.palletsprojects.com/) - Framework web Python
- [LM Studio](https://lmstudio.ai/) - Interface IA locale
- [Mistral AI](https://mistral.ai/) - Modèle de langage

### Personnages historiques

Les portraits et informations biographiques sont utilisés à des fins éducatives et de divertissement.

---

## Licence

Ce projet est propriétaire. Tous droits réservés © MIA - La Maison de l'IA 2025.

---

<p align="center">
  <strong>Chatbot Éternel</strong><br>
  <em>Quand les géants de la médecine se rencontrent...</em>
</p>
