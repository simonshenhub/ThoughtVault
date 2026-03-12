-- ThoughtVault: Supabase Schema
-- Run this in your Supabase SQL Editor (https://supabase.com/dashboard → SQL Editor)

create table quotes (
  id uuid default gen_random_uuid() primary key,
  text text not null,
  category text not null,
  source text not null,
  created_at timestamptz default now(),
  is_favourite boolean default false
);

-- Enable Row Level Security
alter table quotes enable row level security;

-- Allow anonymous inserts (for the web form)
create policy "Allow anonymous inserts"
  on quotes for insert
  to anon
  with check (true);

-- Allow anonymous reads (for the iOS app)
create policy "Allow anonymous reads"
  on quotes for select
  to anon
  using (true);

-- Allow anonymous updates (for favouriting in the iOS app)
create policy "Allow anonymous updates"
  on quotes for update
  to anon
  using (true)
  with check (true);

-- Allow anonymous deletes (for the iOS app)
create policy "Allow anonymous deletes"
  on quotes for delete
  to anon
  using (true);
