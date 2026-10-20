window.LVProfiles={
key:'lv-profile-list',
list(){try{return JSON.parse(localStorage.getItem(this.key)||'[]')}catch{return []}},
add(email,name){const arr=this.list().filter(x=>x.email!==email);arr.push({email,name});localStorage.setItem(this.key,JSON.stringify(arr.slice(-10)))},
remove(email){localStorage.setItem(this.key,JSON.stringify(this.list().filter(p=>p.email!==email)))},
update(email,patch){const arr=this.list();const p=arr.find(x=>x.email===email);if(p){Object.assign(p,patch);localStorage.setItem(this.key,JSON.stringify(arr))}},
client:window.supabase.createClient('https://tmeyazvnysjwxwmfubtv.supabase.co','sb_publishable_XoZoD_APgX7HlYfUQ6t9xQ_0DAjx-N2')
};