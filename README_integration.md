# Intégration de Superset dans Laravel

## 1. Configuration des variables d'environnement

Ajouter les paramètres suivants dans le fichier `.env` afin de permettre à Laravel de communiquer avec Superset :

```env
SUPERSET_URL=http://localhost:8088
SUPERSET_INTERNAL_URL=http://superset:8088
SUPERSET_USERNAME=son_admin
SUPERSET_PASSWORD=son_mot_de_passe
SUPERSET_GUEST_ROLE=Public
SUPERSET_DASHBOARD_ID=id_du_dashboard_a_afficher
```

### Description des variables

| Variable              | Description                                  |
| --------------------- | -------------------------------------------- |
| SUPERSET_URL          | URL publique de Superset                     |
| SUPERSET_INTERNAL_URL | URL interne utilisée entre conteneurs Docker |
| SUPERSET_USERNAME     | Nom d'utilisateur administrateur Superset    |
| SUPERSET_PASSWORD     | Mot de passe administrateur Superset         |
| SUPERSET_GUEST_ROLE   | Rôle attribué aux utilisateurs invités       |
| SUPERSET_DASHBOARD_ID | Identifiant du dashboard à intégrer          |

---

## 2. Configuration du service Superset

Ajouter la configuration suivante dans le fichier `config/services.php` :

```php
'superset' => [
    'url' => env('SUPERSET_URL', 'http://localhost:8088'),
    'internal_url' => env('SUPERSET_INTERNAL_URL', env('SUPERSET_URL')),
    'username' => env('SUPERSET_USERNAME'),
    'password' => env('SUPERSET_PASSWORD'),
    'guest_role' => env('SUPERSET_GUEST_ROLE', 'Public'),
    'dashboard_id' => env('SUPERSET_DASHBOARD_ID'),
],
```

Cette configuration centralise les paramètres utilisés par l'application pour accéder à Superset.

---

## 3. Mise en place du service Superset

Copier le fichier `SupersetService.php` dans le répertoire :

```text
app/Services/
```

Ce service est responsable de :

* l'authentification auprès de l'API Superset ;
* la récupération du token administrateur (`Access Token`) ;
* la génération des tokens invités (`Guest Token`) nécessaires à l'intégration des dashboards.

---

## 4. Création de l'endpoint de génération du token invité

Ajouter une méthode dans le contrôleur concerné afin de fournir un token d'accès temporaire au front-end.

```php
public function guestToken(\App\Services\SupersetService $supersetService)
{
    $user = auth()->user();

    $token = $supersetService->getGuestToken([
        'username' => $user->email,
        'first_name' => $user->first_name ?? 'Invité',
        'last_name' => $user->last_name ?? 'User'
    ]);

    if ($token) {
        return response()->json(['token' => $token]);
    }

    return response()->json([
        'error' => 'Impossible de générer le token'
    ], 500);
}
```

Déclarer ensuite la route associée :

```php
Route::get(
    '/superset/guest-token',
    [StaticienController::class, 'guestToken']
)->name('superset.token');
```

Cette route sera appelée par le front-end pour récupérer le token nécessaire à l'affichage du dashboard.

---

## 5. Intégration Front-End

### Installation du SDK Superset

Installer le package officiel :

```bash
npm install @superset-ui/embedded-sdk
```

### Intégration du script

Ajouter le fichier `superset.js` dans le projet et l'inclure dans le système de build JavaScript.

Ce script :

1. récupère le token via l'API Laravel ;
2. initialise le SDK Superset ;
3. affiche automatiquement le dashboard dans la page.

### Ajout du conteneur dans la vue Blade

Dans la vue où le dashboard doit être affiché, ajouter :

```html
<div
    id="superset-container"
    data-dashboard-id="{{ config('services.superset.dashboard_id') }}"
    data-token-url="{{ route('superset.token') }}"
    data-superset-url="{{ config('services.superset.url') }}"
    style="width: 100%; height: 600px;"
></div>
```

---

## Structure des fichiers à récupérer

Pour reproduire l'intégration, il suffit de récupérer et d'intégrer les éléments suivants :

```text
app/
└── Services/
    └── SupersetService.php

app/
└── Http/
    └── Controllers/
        └── StaticienController.php

config/
└── services.php

resources/
└── js/
    └── superset.js
```

## Flux d'exécution

1. L'utilisateur ouvre la page Laravel.
2. Le script `superset.js` appelle la route `/superset/guest-token`.
3. Laravel utilise `SupersetService` pour générer un Guest Token.
4. Le token est renvoyé au front-end.
5. Le SDK Superset initialise l'iframe sécurisée.
6. Le dashboard Superset est affiché dans la page Laravel.
