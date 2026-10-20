-- v0.16: gallery comment/reply deletion repair
-- Run once in Supabase SQL Editor.
alter table public.commission_comments add column if not exists user_id uuid references auth.users(id);
alter table public.commission_comments enable row level security;
drop policy if exists "Delete own gallery comments v16" on public.commission_comments;
create policy "Delete own gallery comments v16"
on public.commission_comments for delete to authenticated
using (user_id = (select auth.uid()));
-- Replies should not block deletion of a parent comment.
-- Preserve other people's replies as top-level comments rather than deleting them.
do $$
declare fk record;
begin
 for fk in
  select conname from pg_constraint
  where conrelid='public.commission_comments'::regclass
    and contype='f'
    and confrelid='public.commission_comments'::regclass
 loop
  execute format('alter table public.commission_comments drop constraint %I',fk.conname);
 end loop;
end $$;
alter table public.commission_comments
 add constraint commission_comments_parent_id_fkey
 foreign key (parent_id) references public.commission_comments(id) on delete set null;
-- Do not assign missing historic user_id values by nickname: nickname is not proof of ownership.
