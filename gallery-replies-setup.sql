-- 갤러리 댓글에 답글 연결 필드 추가
alter table public.commission_comments
  add column if not exists parent_id uuid references public.commission_comments(id) on delete cascade;
create index if not exists commission_comments_parent_idx on public.commission_comments(parent_id);
-- 기존 댓글 작성 및 읽기 정책을 그대로 사용합니다.
