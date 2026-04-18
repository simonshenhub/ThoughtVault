-- ThoughtVault: Supabase Schema
-- Lives in the `shenboys` Supabase project under a dedicated `thoughtvault`
-- schema so it's isolated from the other tables in `public`.
--
-- To apply: Supabase Dashboard → SQL Editor → paste and run.
-- After applying, add `thoughtvault` to Settings → API → Exposed Schemas
-- so PostgREST will serve it.

create schema if not exists thoughtvault;

create table thoughtvault.quotes (
  id uuid default gen_random_uuid() primary key,
  text text not null,
  category text not null,
  source text not null,
  created_at timestamptz default now(),
  is_favourite boolean default false
);

alter table thoughtvault.quotes enable row level security;

-- Allow anonymous inserts (for the web form)
create policy "Allow anonymous inserts"
  on thoughtvault.quotes for insert
  to anon
  with check (true);

-- Allow anonymous reads (for the iOS app)
create policy "Allow anonymous reads"
  on thoughtvault.quotes for select
  to anon
  using (true);

-- Allow anonymous updates (for favouriting in the iOS app)
create policy "Allow anonymous updates"
  on thoughtvault.quotes for update
  to anon
  using (true)
  with check (true);

-- Allow anonymous deletes (for the iOS app)
create policy "Allow anonymous deletes"
  on thoughtvault.quotes for delete
  to anon
  using (true);

grant usage on schema thoughtvault to anon, authenticated;
grant all on thoughtvault.quotes to anon, authenticated;

-- Expose the schema to PostgREST. The dashboard UI (Integrations → Data API →
-- Settings → Exposed schemas) can get stuck showing unsaved chips, so we set
-- the authenticator role config directly. Adjust the list if other schemas
-- were already exposed.
alter role authenticator set pgrst.db_schemas = 'public, graphql_public, health, thoughtvault';
notify pgrst, 'reload config';
notify pgrst, 'reload schema';

-- Clients must send `Accept-Profile: thoughtvault` (reads) and
-- `Content-Profile: thoughtvault` (writes) to route through PostgREST.
