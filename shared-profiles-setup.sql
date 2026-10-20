-- 모든 기기에서 프로필 닉네임과 사진을 표시합니다.
-- commission_profiles에는 이메일이나 비밀번호가 없으며, 공개 목록은 닉네임/사진만 조회합니다.
alter table public.commission_profiles enable row level security;
do $$ begin if not exists(select 1 from pg_policies where schemaname='public' and tablename='commission_profiles' and policyname='Public profile directory') then create policy "Public profile directory" on public.commission_profiles for select to anon,authenticated using(true); end if; end $$;
-- 로그인한 사용자가 자신의 프로필을 생성/수정할 수 있도록 기존 Own profile 정책을 유지합니다.
-- 갤러리 및 프로필 사진 업로드는 기존 commission-images 저장소 정책을 사용합니다.