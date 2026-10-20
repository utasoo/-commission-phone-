-- v0.12: 답글 재게시를 타임라인 게시물로 표시
alter table public.profile_posts add column if not exists repost_comment_id uuid references public.profile_comments(id) on delete set null;
create index if not exists profile_posts_repost_comment_idx on public.profile_posts(repost_comment_id);
