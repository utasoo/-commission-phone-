window.LVProfiles={
key:'lv-profile-list',
list(){try{return JSON.parse(localStorage.getItem(this.key)||'[]')}catch{return []}},
add(email,name){const arr=this.list().filter(x=>x.email!==email);arr.push({email,name});localStorage.setItem(this.key,JSON.stringify(arr.slice(-10)))},
client:window.supabase.createClient('https://tmeyazvnysjwxwmfubtv.supabase.co','sb_publishable_XoZoD_APgX7HlYfUQ6t9xQ_0DAjx-N2')
};