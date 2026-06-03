docker compose up -d superset
superset fab create-admin, superset db upgrade, superset init
Lancer fix_permissions.sh pour réparer le rôle Public.
Créer un dashboard et lancer enable_embed.sh pour l'activer pour Laravel.



Details 


# Installation et configuration de Superset avec Docker

## 1. Prérequis

Avant de commencer, vérifier que les outils suivants sont installés et fonctionnels sur la machine :

* Docker
* Docker Compose

Vérifier également que le service Docker est démarré.

---

## 2. Déploiement du conteneur Superset

### Intégration des fichiers de configuration

Ajouter la configuration Superset dans le fichier `docker-compose.yml` du projet.

Les fichiers suivants doivent également être présents :

```text
Superset.Dockerfile
superset_config.py
```

Veiller à respecter les chemins utilisés dans la configuration Docker.

### Construction et démarrage du conteneur

Depuis la racine du projet, exécuter les commandes suivantes :

```bash
docker compose build superset
docker compose up -d superset
```

Ces commandes permettent :

* de construire l'image Docker de Superset ;
* de créer et démarrer le conteneur en arrière-plan.

---

## 3. Initialisation de Superset

Lors du premier démarrage, Superset doit être initialisé manuellement afin de créer sa base de données interne et le compte administrateur.

### Création du compte administrateur

Exécuter la commande suivante :

```bash
docker compose exec superset superset fab create-admin \
    --username admin \
    --firstname Superset \
    --lastname Admin \
    --email admin@superset.com \
    --password admin
```

> Les identifiants peuvent être modifiés selon les besoins du projet.

### Mise à jour de la base de données

```bash
docker compose exec superset superset db upgrade
```

Cette commande crée et met à jour les tables internes utilisées par Superset.

### Initialisation des rôles et permissions

```bash
docker compose exec superset superset init
```

Cette étape crée les rôles et permissions par défaut nécessaires au fonctionnement de la plateforme.

---

## 4. Configuration des permissions pour l'intégration embarquée (Embed)

Afin d'autoriser l'affichage des dashboards via l'Embedded SDK et les Guest Tokens, certaines permissions doivent être ajoutées au rôle `Public`.

### Exécution du script de permissions

Si le fichier `fix_permissions.sh` est disponible, exécuter :

```bash
docker compose exec -T superset bash < fix_permissions.sh
```

Le script ajoute automatiquement les permissions nécessaires au rôle Public, notamment :

* accès aux dashboards ;
* accès aux graphiques ;
* accès aux dashboards embarqués ;
* permissions de lecture requises par les Guest Tokens.

---

## 5. Activation de l'intégration d'un Dashboard

Après avoir créé un dashboard dans Superset, il est nécessaire d'activer le mode "Embedded" afin qu'il puisse être affiché dans une application externe.

### Exécution du script d'activation

Si le fichier `enable_embed.sh` est fourni, exécuter :

```bash
bash enable_embed.sh
```

Ce script :

* se connecte à l'API Superset ;
* active l'intégration embarquée du dashboard ;
* génère les informations nécessaires à son intégration.

### Points d'attention

Le script est configuré par défaut avec :

```text
Dashboard ID : 1
Username     : admin
Password     : admin
```

Si le dashboard possède un autre identifiant ou si les identifiants administrateur sont différents, le script devra être adapté avant son exécution.

---

## Vérification de l'installation

Une fois toutes les étapes terminées, Superset doit être accessible depuis un navigateur à l'adresse :

```text
http://localhost:8088
```

Connectez-vous avec le compte administrateur créé précédemment afin de :

1. Créer les sources de données.
2. Créer les graphiques.
3. Créer les dashboards.
4. Activer l'option Embedded sur les dashboards destinés à être intégrés dans Laravel.

---

## Structure des fichiers à récupérer

Pour reproduire l'installation, les fichiers suivants doivent être intégrés au projet :

```text
docker-compose.yml
Superset.Dockerfile
superset_config.py
fix_permissions.sh
enable_embed.sh
```

## Flux d'installation

1. Ajouter les fichiers de configuration Docker.
2. Construire l'image Superset.
3. Démarrer le conteneur.
4. Créer le compte administrateur.
5. Mettre à jour la base de données interne.
6. Initialiser Superset.
7. Appliquer les permissions Embed.
8. Créer un dashboard.
9. Activer le mode Embedded.
10. Utiliser le Dashboard dans l'application Laravel via Guest Token.
