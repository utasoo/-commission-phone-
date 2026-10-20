-- v0.9: Reply photos and timestamped reaction notifications
alter table public.profile_comments add column if not exists image_path text;
alter table public.profile_comment_likes add column if not exists created_at timestamptz not null default now();
alter table public.profile_comment_reposts add column if not exists created_at timestamptz not null default now();
create index if not exists profile_comments_parent_created_idx on public.profile_comments(parent_id,created_at);
-- The existing commission-images bucket and upload policies must permit uploads to reply-images/<user_id>/.
