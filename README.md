# Application Flutter de Gestion des Livres

Une application Flutter complète pour la gestion d'une bibliothèque personnelle avec un focus sur la manipulation des données.

## 🚀 Fonctionnalités

### Gestion des Livres (CRUD)
- ✅ **Ajouter** des livres avec informations complètes
- ✅ **Modifier** les détails des livres existants
- ✅ **Supprimer** des livres avec confirmation
- ✅ **Visualiser** les détails complets d'un livre

### Manipulation des Données
- ✅ **Recherche avancée** par titre, auteur, genre
- ✅ **Filtrage** par genre
- ✅ **Tri** par différents critères (titre, auteur, année, prix, note, date d'ajout)
- ✅ **Statistiques** détaillées de la bibliothèque
- ✅ **Persistance** avec base de données SQLite locale

### Interface Utilisateur
- ✅ **Design moderne** avec Material Design 3
- ✅ **Navigation intuitive** entre les écrans
- ✅ **Formulaires validés** pour la saisie de données
- ✅ **Feedback utilisateur** avec messages de confirmation/erreur

### Fonctionnalités Avancées
- ✅ **Statut de lecture** (lu/non lu)
- ✅ **Système de notation** (1-5 étoiles)
- ✅ **Données de test** pré-chargées
- ✅ **Gestion d'état** avec Provider
- 🔄 **Import/Export CSV** (en développement)

## 📱 Écrans de l'Application

1. **Écran d'accueil** - Liste des livres avec recherche et filtres
2. **Ajout/Modification** - Formulaire complet pour gérer les livres
3. **Détails du livre** - Vue détaillée avec actions rapides
4. **Statistiques** - Tableaux de bord et analyses

## 🛠️ Technologies Utilisées

- **Flutter** - Framework de développement mobile
- **SQLite** - Base de données locale pour la persistance
- **Provider** - Gestion d'état
- **Material Design 3** - Interface utilisateur moderne

### Dépendances Principales
```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0      # Base de données SQLite
  provider: ^6.0.5     # Gestion d'état
  intl: ^0.18.1        # Formatage des dates/devises
  path: ^1.8.3         # Gestion des chemins de fichiers
```

## 🏗️ Architecture du Projet

```
lib/
├── main.dart                 # Point d'entrée de l'application
├── models/
│   └── book.dart            # Modèle de données Book
├── providers/
│   └── book_provider.dart   # Gestion d'état avec Provider
├── screens/
│   ├── home_screen.dart     # Écran principal
│   ├── add_edit_book_screen.dart # Formulaire ajout/modification
│   ├── book_detail_screen.dart   # Détails d'un livre
│   └── statistics_screen.dart    # Écran des statistiques
├── widgets/
│   ├── book_list_widget.dart     # Liste des livres
│   └── search_filter_widget.dart # Barre de recherche et filtres
└── utils/
    └── database_helper.dart      # Gestion de la base de données
```

## 🚀 Installation et Lancement

### Prérequis
- Flutter SDK (version 3.0.0 ou supérieure)
- Android Studio ou VS Code avec extensions Flutter
- Émulateur Android ou appareil physique

### Étapes d'installation

1. **Cloner le projet**
```bash
git clone <url-du-repo>
cd flutter-data-mgmt-app
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Lancer l'application**
```bash
flutter run
```

## 📊 Fonctionnalités de Manipulation des Données

### 1. Opérations CRUD
- **Create** : Ajout de nouveaux livres avec validation des données
- **Read** : Lecture et affichage des livres avec pagination
- **Update** : Modification des informations existantes
- **Delete** : Suppression avec confirmation utilisateur

### 2. Recherche et Filtrage
- Recherche en temps réel dans le titre, auteur, et genre
- Filtrage par genre avec liste déroulante
- Combinaison de recherche et filtres

### 3. Tri des Données
- Tri par titre (A-Z / Z-A)
- Tri par auteur (A-Z / Z-A)
- Tri par année de publication (croissant/décroissant)
- Tri par prix (croissant/décroissant)
- Tri par note (croissant/décroissant)
- Tri par date d'ajout (récent/ancien)

### 4. Statistiques et Analyses
- Nombre total de livres
- Livres lus vs non lus
- Note moyenne de la bibliothèque
- Valeur totale de la collection
- Répartition par genre avec graphiques
- Progression de lecture

### 5. Validation des Données
- Validation des champs obligatoires
- Vérification du format ISBN
- Contrôle des années de publication
- Validation des prix et nombres de pages
- Gestion des erreurs avec messages explicites

## 🎯 Cas d'Usage pour Tester la Manipulation des Données

### Test 1: Ajout de Livres
1. Cliquer sur le bouton "+" pour ajouter un livre
2. Remplir le formulaire avec des données valides/invalides
3. Tester la validation des champs
4. Vérifier la sauvegarde en base de données

### Test 2: Recherche et Filtrage
1. Utiliser la barre de recherche pour chercher par titre
2. Tester la recherche par auteur
3. Appliquer des filtres par genre
4. Combiner recherche et filtres

### Test 3: Tri des Données
1. Tester tous les critères de tri disponibles
2. Alterner entre ordre croissant et décroissant
3. Vérifier la persistance du tri choisi

### Test 4: Modification et Suppression
1. Modifier les informations d'un livre existant
2. Tester la suppression avec confirmation
3. Vérifier la mise à jour en temps réel

### Test 5: Statistiques
1. Consulter l'écran des statistiques
2. Vérifier la cohérence des données affichées
3. Tester l'actualisation des statistiques

## 🔧 Personnalisation

L'application est conçue pour être facilement extensible :

- **Nouveaux champs** : Ajouter des propriétés au modèle Book
- **Nouveaux filtres** : Étendre les critères de recherche
- **Export/Import** : Implémenter les fonctionnalités CSV
- **Thèmes** : Personnaliser l'apparence avec des thèmes

## 📝 Notes de Développement

Cette application démontre les concepts clés de manipulation des données dans Flutter :

1. **Persistance locale** avec SQLite
2. **Gestion d'état réactive** avec Provider
3. **Validation de formulaires** robuste
4. **Interface utilisateur responsive**
5. **Architecture MVVM** claire et maintenable

L'accent est mis sur les bonnes pratiques de développement Flutter et la manipulation efficace des données pour une expérience utilisateur optimale.