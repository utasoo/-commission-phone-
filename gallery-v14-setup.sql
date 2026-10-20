-- v0.14: 갤러리 댓글/대댓글 삭제 권한
alter table public.commission_comments add column if not exists user_id uuid references auth.users(id);
alter table public.commission_comments enable row level security;
drop policy if exists "Delete own gallery comments v14" on public.commission_comments;
create policy "Delete own gallery comments v14"
on public.commission_comments for delete to authenticated
using (user_id = auth.uid());
-- 과거 댓글 중 user_id가 비어 있는 것은 작성자를 검증할 수 없어 자동 소유권 부여하지 않습니다.
