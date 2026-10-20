-- Supabase SQL Editor에서 한 번 실행하세요.
create table if not exists public.profile_posts (id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade, content text not null check(char_length(content) between 1 and 500), repost_of uuid references public.profile_posts(id) on delete set null, created_at timestamptz default now());
create table if not exists public.profile_likes (post_id uuid references public.profile_posts(id) on delete cascade, user_id uuid references auth.users(id) on delete cascade, primary key(post_id,user_id));
create table if not exists public.profile_comments (id uuid primary key default gen_random_uuid(), post_id uuid references public.profile_posts(id) on delete cascade, user_id uuid references auth.users(id) on delete cascade, content text not null check(char_length(content) between 1 and 500), created_at timestamptz default now());
alter table public.profile_posts enable row level security;
alter table public.profile_likes enable row level security;
alter table public.profile_comments enable row level security;
create policy "Read profile posts" on public.profile_posts for select to authenticated using(true);
create policy "Create own profile posts" on public.profile_posts for insert to authenticated with check(user_id=auth.uid());
create policy "Delete own profile posts" on public.profile_posts for delete to authenticated using(user_id=auth.uid());
create policy "Read profile likes" on public.profile_likes for select to authenticated using(true);
create policy "Like as self" on public.profile_likes for insert to authenticated with check(user_id=auth.uid());
create policy "Unlike as self" on public.profile_likes for delete to authenticated using(user_id=auth.uid());
create policy "Read profile comments" on public.profile_comments for select to authenticated using(true);
create policy "Comment as self" on public.profile_comments for insert to authenticated with check(user_id=auth.uid());
create policy "Delete own profile comments" on public.profile_comments for delete to authenticated using(user_id=auth.uid());