-- Novo OpsHub - Supabase backend setup
-- Run this ONCE in Supabase: SQL Editor -> New query -> paste -> Run.

-- 1) Tables ---------------------------------------------------------------
-- Every record from every section is one row in "records"
-- (module = 'tasks', 'vendors', 'invoices', ...; data = the record itself).
create table if not exists public.records (
  id         text primary key,
  module     text not null,
  data       jsonb not null default '{}'::jsonb,
  updated_by text,
  created_at timestamptz not null default now()
);
create index if not exists records_module_idx on public.records (module);

-- Activity log
create table if not exists public.activity (
  id     bigint generated always as identity primary key,
  ts     timestamptz not null default now(),
  usr    text,
  action text,
  module text,
  rec    text
);
create index if not exists activity_ts_idx on public.activity (ts desc);

-- 2) Security: only signed-in users can read or write --------------------------
alter table public.records  enable row level security;
alter table public.activity enable row level security;

drop policy if exists "team_records"  on public.records;
drop policy if exists "team_activity" on public.activity;

create policy "team_records"  on public.records
  for all to authenticated using (true) with check (true);
create policy "team_activity" on public.activity
  for all to authenticated using (true) with check (true);

-- Block the public (not-signed-in) role completely
revoke all on public.records  from anon;
revoke all on public.activity from anon;
