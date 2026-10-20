-- v0.13: 갤러리에서 내가 올린 사진 삭제 허용
alter table public.commission_posts enable row level security;
drop policy if exists "Delete own gallery photos v13" on public.commission_posts;
create policy "Delete own gallery photos v13"
on public.commission_posts for delete to authenticated
using (user_id = auth.uid());
-- Storage: 본인 uploads/<uid>/ 아래 파일만 삭제 허용
drop policy if exists "Delete own gallery uploads v13" on storage.objects;
create policy "Delete own gallery uploads v13"
on storage.objects for delete to authenticated
using (
 bucket_id = 'commission-images'
 and (storage.foldername(name))[1] = 'uploads'
 and (storage.foldername(name))[2] = auth.uid()::text
);
