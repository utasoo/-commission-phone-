-- 새 사진 게시물과 삭제 권한
alter table public.profile_posts add column if not exists image_path text;
-- 본인 프로필 글만 삭제 가능 (기존 정책이 이미 있다면 중복 생성하지 않음)
do $$ begin if not exists(select 1 from pg_policies where schemaname='public' and tablename='profile_posts' and policyname='Delete own profile posts') then create policy "Delete own profile posts" on public.profile_posts for delete to authenticated using(user_id=auth.uid()); end if; end $$;
-- 갤러리 사진: 본인이 업로드한 것만 삭제
alter table public.commission_posts enable row level security;
do $$ begin if not exists(select 1 from pg_policies where schemaname='public' and tablename='commission_posts' and policyname='Delete own gallery photos') then create policy "Delete own gallery photos" on public.commission_posts for delete to authenticated using(user_id=auth.uid()); end if; end $$;
-- 저장소 이미지 삭제 권한: 본인 소유의 객체만 삭제
-- 기존 storage.objects RLS 정책과 함께 적용됨
do $$ begin if not exists(select 1 from pg_policies where schemaname='storage' and tablename='objects' and policyname='Remove own commission images') then create policy "Remove own commission images" on storage.objects for delete to authenticated using(bucket_id='commission-images' and owner_id=(select auth.uid()::text)); end if; end $$;