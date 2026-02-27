# Chatbot Éternel - MIA La Maison de l'IA

**Dialogues fictifs entre grandes figures de l'Histoire et de la fiction**

Un chatbot interactif qui simule des conversations entre personnages historiques et fictifs célèbres, propulsé par l'IA locale via LM Studio.

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

**Chatbot Éternel** est une application web qui génère des dialogues fictifs et automatiques entre deux personnages célèbres de l'Histoire ou de la fiction. L'IA joue alternativement chaque rôle, créant des échanges fascinants sur la science, l'art, la philosophie, l'histoire et la vie.

### Fonctionnalités

- **23 personnages** avec des personnalités distinctes (historiques et fictifs)
- **IA locale** via LM Studio (pas de données envoyées sur internet)
- **Dialogues automatiques** qui s'enchaînent naturellement
- **Interface moderne** avec thème sombre élégant
- **Design responsive** (desktop, tablette, mobile)
- **Scripts automatisés** pour Windows et Linux

---

## Personnages

### Groupe 1 (Panel gauche)

| Personnage | Époque | Domaine |
|------------|--------|---------|
| **Ada Lovelace** | 1815-1852 | Mathématiques, Informatique |
| **Hildegarde de Bingen** | 1098-1179 | Médecine naturelle, Mysticisme |
| **Florence Nightingale** | 1820-1910 | Soins infirmiers, Hygiène |
| **Marie Curie** | 1867-1934 | Radioactivité, Physique |
| **Rosalind Franklin** | 1920-1958 | Cristallographie, ADN |
| **Coco Chanel** | 1883-1971 | Mode, Élégance |
| **Édith Piaf** | 1915-1963 | Musique, Chanson française |
| **Marie Antoinette** | 1755-1793 | Histoire de France |
| **Simone Veil** | 1927-2017 | Politique, Droits des femmes |
| **Nikola Tesla** | 1856-1943 | Invention, Électricité |
| **Dumbledore** | Fiction | Sorcellerie (Harry Potter) |
| **Voldemort** | Fiction | Magie noire (Harry Potter) |

### Groupe 2 (Panel droit)

| Personnage | Époque | Domaine |
|------------|--------|---------|
| **Hippocrate** | ~460-370 av. J.-C. | Médecine rationnelle |
| **Avicenne** | 980-1037 | Médecine, Philosophie |
| **Louis Pasteur** | 1822-1895 | Microbiologie, Vaccination |
| **Alexander Fleming** | 1881-1955 | Pénicilline, Antibiotiques |
| **Alan Turing** | 1912-1954 | Informatique, Cryptologie |
| **Jean-Michel Basquiat** | 1960-1988 | Art contemporain |
| **Albert Camus** | 1913-1960 | Littérature, Philosophie |
| **Sigmund Freud** | 1856-1939 | Psychanalyse |
| **Napoléon** | 1769-1821 | Histoire militaire, Politique |
| **Paul Walker** | 1973-2013 | Cinéma, Humanitaire |
| **Darth Vader** | Fiction | Côté Obscur (Star Wars) |

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
┌──────────────────────────────────────────────────────────────┐
│  [Groupe 1]        CHATBOT ÉTERNEL            [Groupe 2]     │
│                                                              │
│  Ada         ┌──────────────────────────┐    Hippocrate      │
│  Hildegarde  │  Marie Curie:            │    Avicenne        │
│  Nightingale │  "Bonjour Napoléon !"    │    Pasteur         │
│  M. Curie    │                          │    Fleming         │
│  Franklin    │  Napoléon:               │    Turing          │
│  Chanel      │  "Chère Marie !"         │    Basquiat        │
│  Piaf        └──────────────────────────┘    Camus           │
│  Antoinette                                  Freud           │
│  S. Veil                                     Napoléon        │
│  Tesla                                       P. Walker       │
│  Dumbledore                                  Darth Vader     │
│  Voldemort                                                   │
└──────────────────────────────────────────────────────────────┘
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
│   └── *.png/jpg/webp     # Portraits des 23 personnages
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

### Personnages historiques et fictifs

Les portraits et informations biographiques sont utilisés à des fins éducatives et de divertissement.

---

## Licence

Ce projet est propriétaire. Tous droits réservés © MIA - La Maison de l'IA 2025.

---

<p align="center">
  <strong>Chatbot Éternel</strong><br>
  <em>Quand les grandes figures de l'Histoire se rencontrent...</em>
</p>
