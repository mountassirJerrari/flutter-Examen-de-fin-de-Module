# Application de Messagerie Flutter

## 📱 Aperçu du Projet
Application de messagerie mobile développée avec Flutter implémentant le pattern BLoC pour la gestion d'état. L'application permet aux utilisateurs de visualiser leurs conversations, d'envoyer et de recevoir des messages en temps réel.

## 🎯 Fonctionnalités Implémentées

### 1. Écran de Liste des Conversations
- Affichage de la liste des conversations avec avatar personnalisé
- Dernier message échangé avec horodatage
- Badge de notification pour les messages non lus
- Possibilité de créer une nouvelle conversation
- Interface utilisateur moderne et réactive
- Thème clair/sombre supporté

### 2. Écran de Conversation Détail
- Affichage des messages avec bulles de discussion
- Différenciation visuelle des messages envoyés/reçus
- Champ de texte pour écrire un nouveau message
- Bouton d'envoi de message
- Défilement automatique vers le bas lors de la réception de nouveaux messages
- Menu d'options (effacer la conversation, notifications, etc.)
- Appels vidéo et vocaux (UI seulement)

## 🏗 Architecture et Structure du Projet

### Modèles de Données

#### Conversation
```dart
class Conversation {
  final String id;
  final String contactName;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  
  // Constructeur et méthodes fromJson/toJson
}
```

#### Message
```dart
class Message {
  final String id;
  final String conversationId;
  final String content;
  final DateTime timestamp;
  final bool isMe;
  
  // Constructeur et méthodes fromJson/toJson
}
```

### Gestion d'État avec BLoC

#### États (States)
- `ConversationInitial` : État initial
- `ConversationsLoading` : Chargement des conversations
- `ConversationsLoaded` : Conversations chargées avec succès
- `ConversationError` : Erreur lors du chargement
- `MessagesLoading` : Chargement des messages
- `MessagesLoaded` : Messages chargés avec succès
- `MessageSending` : Envoi de message en cours
- `MessageSent` : Message envoyé avec succès
- `MessageReceived` : Nouveau message reçu

#### Événements (Events)
- `LoadConversations` : Charger la liste des conversations
- `LoadMessages` : Charger les messages d'une conversation
- `SendMessage` : Envoyer un nouveau message
- `ReceiveMessage` : Recevoir un nouveau message
- `CreateConversation` : Créer une nouvelle conversation

## 🛠 Configuration du Projet

### Prérequis
- Flutter SDK (dernière version stable)
- Dart SDK (version 3.0.0 ou supérieure)
- Un émulateur ou appareil physique pour le test

### Installation
1. Cloner le dépôt :
   ```bash
   git clone [URL_DU_DEPOT]
   cd flutter_chat_app
   ```

2. Installer les dépendances :
   ```bash
   flutter pub get
   ```

3. Lancer l'application :
   ```bash
   flutter run
   ```

## 📱 Captures d'Écran

### Écran des Conversations
[Insérer capture d'écran]

### Écran de Discussion
[Insérer capture d'écran]

## 🚀 Fonctionnalités Avancées

### Gestion des Thèmes
- Support natif des thèmes clair/sombre
- Couleurs adaptatives pour une expérience utilisateur cohérente
- Animations fluides pour les transitions d'interface

### Performances
- Optimisation du rendu des listes avec ListView.builder
- Gestion efficace de la mémoire avec les contrôleurs de défilement
- Mise en cache des avatars et des ressources

### Accessibilité
- Étiquettes sémantiques pour les lecteurs d'écran
- Tailles de police adaptatives
- Contraste élevé pour une meilleure lisibilité

## 📚 Documentation Technique

### Structure des Dossiers
```
lib/
├── bloc/               # Logique métier et gestion d'état
│   ├── conversation_bloc.dart
│   ├── conversation_event.dart
│   └── conversation_state.dart
├── models/             # Modèles de données
│   ├── conversation.dart
│   └── message.dart
├── screens/            # Écrans de l'application
│   ├── conversation_detail_screen.dart
│   └── conversation_list_screen.dart
├── widgets/            # Composants réutilisables
│   └── message_bubble.dart
└── main.dart           # Point d'entrée de l'application
```

## 🔍 Points d'Amélioration
- Implémentation de la persistance des données avec Hive ou SQLite
- Ajout de la fonctionnalité de recherche dans les conversations
- Support des pièces jointes (images, documents)
- Intégration avec un service d'authentification
- Tests unitaires et d'intégration

