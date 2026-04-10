# AMAJAZZ – Band Manager

Application web de gestion musicale pour collectifs et associations.

## Fonctionnalités

- **Morceaux** : nom, tonalité, tempo (slider), style, durée, notes d'exécution
- **Musiciens** : organisés par famille d'instrument (cordes, vents, percussions, voix…)
- **Sets** : composition de sets par sélection interactive des morceaux
- **Concerts** : gestion des dates avec lieu, heure et set associé
- **Planning** : calendrier mensuel répétitions + concerts
- **Base de données Supabase** : données persistantes et partagées en temps réel

---

## Déploiement — étapes

### 1. Créer la base de données Supabase

1. Créez un compte sur https://supabase.com (gratuit)
2. Créez un nouveau projet (nom : `amajazz`, mot de passe fort)
3. Dans le menu gauche : **SQL Editor** → **New Query**
4. Copiez-collez le contenu du fichier `supabase_schema.sql`
5. Cliquez **Run** — toutes les tables sont créées

6. Récupérez vos clés dans **Settings → API** :
   - `Project URL` → c'est votre `SUPABASE_URL`
   - `anon public` key → c'est votre `SUPABASE_ANON_KEY`

### 2. Configurer l'application

Dans `index.html`, ligne ~400, remplacez :
```js
const SUPABASE_URL  = 'VOTRE_SUPABASE_URL';
const SUPABASE_ANON = 'VOTRE_SUPABASE_ANON_KEY';
```

Par vos vraies valeurs, par exemple :
```js
const SUPABASE_URL  = 'https://xxxxxxxxxxxx.supabase.co';
const SUPABASE_ANON = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

### 3. Publier sur Vercel

**Option A – Via GitHub (recommandé)**

1. Créez un dépôt GitHub (public ou privé) : `amajazz`
2. Poussez les fichiers :
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/VOTRE_USER/amajazz.git
   git push -u origin main
   ```
3. Sur https://vercel.com → **New Project** → importez le dépôt GitHub
4. Vercel détecte automatiquement le projet statique
5. Cliquez **Deploy** → votre app est en ligne en 1 minute !

**Option B – Via Vercel CLI**

```bash
npm install -g vercel
cd amajazz
vercel deploy
```

---

## Personnalisation

### Changer le nom de l'association

Dans `index.html`, cherchez `AMAJAZZ` et remplacez par votre nom.

### Adapter pour SKYROAD ou un autre groupe

Dupliquez le projet Supabase (nouveau projet) + nouveau déploiement Vercel.
Les données sont totalement indépendantes.

### Sécuriser l'accès (optionnel)

Par défaut l'app est accessible à tous (politique RLS permissive).
Pour restreindre l'accès, activez l'authentification Supabase :
1. Supabase → **Authentication** → activez Email/Password
2. Modifiez les policies RLS pour `auth.role() = 'authenticated'`
3. Ajoutez un formulaire de login dans l'app

---

## Structure des fichiers

```
amajazz/
├── index.html          ← Application complète (HTML + CSS + JS)
├── vercel.json         ← Configuration déploiement Vercel
├── supabase_schema.sql ← Script création base de données
└── README.md           ← Ce fichier
```

---

## Tables Supabase

| Table | Description |
|-------|-------------|
| `songs` | Morceaux (nom, tonalité, tempo, style, notes, durée) |
| `members` | Musiciens (prénom, nom, pseudo, famille, instrument, avatar) |
| `sets` | Sets de morceaux |
| `set_songs` | Liaison sets ↔ morceaux (avec ordre) |
| `concerts` | Concerts (date, heure, lieu, set associé, notes) |
| `events` | Répétitions et autres événements |
| `instrument_families` | Référentiel familles d'instruments |
