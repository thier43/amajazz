-- ============================================================
--  AMAJAZZ – BandManager  •  Supabase schema
-- ============================================================

-- Morceaux
create table if not exists songs (
  id          bigint generated always as identity primary key,
  name        text not null,
  style       text,
  key         text,
  tempo       int default 120,
  notes       text,
  duration    int,
  created_at  timestamptz default now()
);

-- Familles d'instruments
create table if not exists instrument_families (
  id    bigint generated always as identity primary key,
  name  text not null unique
);

insert into instrument_families (name) values
  ('Cordes'),('Vents bois'),('Vents cuivres'),
  ('Percussions'),('Claviers'),('Voix'),('Basses'),('Autre')
on conflict do nothing;

-- Musiciens
create table if not exists members (
  id          bigint generated always as identity primary key,
  prenom      text not null,
  nom         text,
  pseudo      text,
  family      text,
  instrument  text,
  avatar      text,
  created_at  timestamptz default now()
);

-- Sets
create table if not exists sets (
  id          bigint generated always as identity primary key,
  name        text not null,
  created_at  timestamptz default now()
);

-- Morceaux dans un set (table pivot avec ordre)
create table if not exists set_songs (
  id       bigint generated always as identity primary key,
  set_id   bigint references sets(id) on delete cascade,
  song_id  bigint references songs(id) on delete cascade,
  position int default 0
);

-- Concerts
create table if not exists concerts (
  id          bigint generated always as identity primary key,
  name        text not null,
  date        date not null,
  time        time,
  venue       text,
  set_id      bigint references sets(id) on delete set null,
  notes       text,
  created_at  timestamptz default now()
);

-- Répétitions / événements
create table if not exists events (
  id          bigint generated always as identity primary key,
  type        text not null default 'repetition',
  date        date not null,
  time        time,
  venue       text,
  notes       text,
  created_at  timestamptz default now()
);

-- RLS (Row Level Security) – tout public pour simplifier (à durcir en prod)
alter table songs            enable row level security;
alter table members          enable row level security;
alter table sets             enable row level security;
alter table set_songs        enable row level security;
alter table concerts         enable row level security;
alter table events           enable row level security;
alter table instrument_families enable row level security;

-- Policies permissives (anon + authenticated)
do $$
declare tbl text;
begin
  foreach tbl in array array['songs','members','sets','set_songs','concerts','events','instrument_families'] loop
    execute format('create policy "allow all" on %I for all using (true) with check (true)', tbl);
  end loop;
end$$;
