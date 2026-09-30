# Novo OpsHub - Setup & Deployment Guide

Files in this repo
- `index.html`  (the app - rename `novo-opshub.html` to `index.html`)
- `supabase-setup.sql`  (database setup)
- `README.md`  (this guide)

Login used by the app: username `novo`, password `novo2026`
(the app turns the username into the email `novo@novo-opshub.com`).

## 1. Supabase (database + login)
1. supabase.com -> New project (pick a region near India, e.g. Mumbai). Save the database password.
2. SQL Editor -> New query -> paste all of `supabase-setup.sql` -> Run.
3. Authentication -> Users -> Add user -> Create new user:
   email `novo@novo-opshub.com`, password `novo2026`, tick **Auto Confirm User** -> Create.
4. Authentication -> Sign In / Providers (or Settings) -> turn OFF "Allow new users to sign up",
   so nobody else can create accounts.
5. Project Settings -> API: copy the **Project URL** and the **anon / publishable key**.
   Never use the `service_role` key anywhere in this app.

## 2. Cloudinary (invoice / document uploads)
1. cloudinary.com -> create a free account. On the dashboard copy the **Cloud name**.
2. Settings -> Upload -> Upload presets -> Add upload preset:
   Signing mode = **Unsigned**, Folder = `novo-opshub`, then Save. Copy the **preset name**.
3. Settings -> Security: enable "PDF and ZIP files delivery" (otherwise PDFs will not open).

## 3. Put the keys in the code
Open `index.html`, find this line near the top of the script and fill the quotes:

    const CFG={url:'https://YOURPROJECT.supabase.co',key:'YOUR_ANON_KEY',cloud:'YOUR_CLOUD_NAME',preset:'YOUR_PRESET'};

The anon key and Cloudinary preset are designed to be public; Supabase security comes from the
login + the policies in `supabase-setup.sql`. Keep the GitHub repo **private** anyway.

## 4. GitHub
1. github.com -> New repository (Private), name `novo-opshub`.
2. Add file -> Upload files -> upload `index.html`, `supabase-setup.sql`, `README.md` -> Commit.

## 5. Cloudflare Pages (deploy)
1. dash.cloudflare.com -> Workers & Pages -> Create -> Pages -> Connect to Git -> pick `novo-opshub`.
2. Framework preset: None. Build command: leave empty. Build output directory: `/`  -> Save and Deploy.
3. You get a link like `https://novo-opshub.pages.dev` - share it with your team.
4. Every time you edit `index.html` on GitHub and commit, Cloudflare redeploys automatically.
5. (Optional) Supabase -> Authentication -> URL Configuration: set Site URL to your Cloudflare link.

## Checking it works
Open the link -> sign in `novo` / `novo2026` -> add a task -> open the link on another device:
the task appears there too (refreshes within ~30 seconds). Upload an invoice -> it appears in
your Cloudinary Media Library under `novo-opshub`.

## Troubleshooting
- "The database is not connected" / login page shows no error: check `url` and `key` have no spaces.
- "Incorrect username or password": user not created, or "Auto Confirm" was not ticked.
- "Load failed / Save failed ... row-level security": re-run `supabase-setup.sql`.
- Upload failed: check cloud name, that the preset is **Unsigned**, and file is under 10 MB.
- Old data in your browser from testing: Settings -> Clear all data (local mode only).
