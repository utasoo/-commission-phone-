-- v0.4: timestamps for likes and only one repost per user per original post
alter table public.profile_likes add column if not exists created_at timestamptz not null default now();
create unique index if not exists profile_one_repost_per_user on public.profile_posts(user_id,repost_of) where repost_of is not null;
-- Existing duplicate reposts must be removed before creating the unique index if this statement fails.
