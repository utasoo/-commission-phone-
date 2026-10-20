-- v0.7: threaded social replies and gallery comment ownership
alter table public.profile_comments add column if not exists parent_id uuid references public.profile_comments(id) on delete cascade;
create index if not exists profile_comments_parent_idx on public.profile_comments(parent_id);
create table if not exists public.profile_comment_likes (
 comment_id uuid not null references public.profile_comments(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,
 primary key(comment_id,user_id)
);
create table if not exists public.profile_comment_reposts (
 comment_id uuid not null references public.profile_comments(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,
 primary key(comment_id,user_id)
);
alter table public.profile_comment_likes enable row level security;
alter table public.profile_comment_reposts enable row level security;
drop policy if exists "Read reply likes" on public.profile_comment_likes;
create policy "Read reply likes" on public.profile_comment_likes for select to authenticated using(true);
drop policy if exists "Write own reply likes" on public.profile_comment_likes;
create policy "Write own reply likes" on public.profile_comment_likes for insert to authenticated with check(user_id=auth.uid());
drop policy if exists "Remove own reply likes" on public.profile_comment_likes;
create policy "Remove own reply likes" on public.profile_comment_likes for delete to authenticated using(user_id=auth.uid());
drop policy if exists "Read reply reposts" on public.profile_comment_reposts;
create policy "Read reply reposts" on public.profile_comment_reposts for select to authenticated using(true);
drop policy if exists "Write own reply reposts" on public.profile_comment_reposts;
create policy "Write own reply reposts" on public.profile_comment_reposts for insert to authenticated with check(user_id=auth.uid());
drop policy if exists "Remove own reply reposts" on public.profile_comment_reposts;
create policy "Remove own reply reposts" on public.profile_comment_reposts for delete to authenticated using(user_id=auth.uid());
alter table public.commission_comments add column if not exists user_id uuid references auth.users(id);
create index if not exists commission_comments_user_idx on public.commission_comments(user_id);
drop policy if exists "Delete own gallery comments v07" on public.commission_comments;
create policy "Delete own gallery comments v07" on public.commission_comments for delete to authenticated using(user_id=auth.uid());
-- Existing gallery comments without user_id remain visible but cannot be ownership-verified for deletion.
