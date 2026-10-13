-- Run this in Supabase: SQL Editor -> New query -> paste -> Run.
-- It is safe to run more than once, and safe if you ran an earlier version.

create table if not exists votes (
  round    text not null check (char_length(round) <= 40),
  voter_id text not null check (char_length(voter_id) <= 64),
  fptp     text,
  rcv      jsonb not null default '[]',
  scores   jsonb not null default '{}',
  created_at timestamptz not null default now(),
  -- one vote per voter ID per round
  primary key (round, voter_id),
  check (jsonb_typeof(rcv) = 'array' and jsonb_array_length(rcv) <= 12),
  check (jsonb_typeof(scores) = 'object')
);

-- Approval voting column
alter table votes add column if not exists approvals jsonb not null default '[]';
alter table votes drop constraint if exists votes_approvals_check;
alter table votes add constraint votes_approvals_check
  check (jsonb_typeof(approvals) = 'array' and jsonb_array_length(approvals) <= 12);

alter table votes enable row level security;

-- Anyone with the link can read results and add a vote.
-- There is no update or delete rule, so votes can't be changed from the web page.
drop policy if exists "anyone can read votes" on votes;
drop policy if exists "anyone can add a vote" on votes;
create policy "anyone can read votes" on votes for select to anon using (true);
create policy "anyone can add a vote" on votes for insert to anon with check (true);

-- ---------------------------------------------------------------
-- "Reset all votes" button
-- The button calls this function to delete every vote for the current round.
-- Anyone who opens the page can use the button (after a confirmation box),
-- so share the link only with your class.
-- ---------------------------------------------------------------
drop function if exists reset_votes(text, text);  -- removes the older passcode version, if you ran it
drop table if exists teacher_settings;

create or replace function reset_votes(p_round text)
returns integer
language plpgsql
security definer
set search_path = public
as $$
declare n integer;
begin
  delete from votes where round = p_round;
  get diagnostics n = row_count;
  return n;
end;
$$;

revoke all on function reset_votes(text) from public;
grant execute on function reset_votes(text) to anon;
