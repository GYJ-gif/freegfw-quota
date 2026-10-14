from pathlib import Path
import base64,gzip,hashlib,io,re,tarfile,textwrap,sys
root=Path(__file__).resolve().parents[1]
p=root/'install-quota.sh'; s=p.read_text(encoding='utf-8')
old=s.split("<<'FREEGFW_QUOTA_SOURCE'\n",1)[1].split('\nFREEGFW_QUOTA_SOURCE',1)[0]
names=tarfile.open(fileobj=io.BytesIO(base64.b64decode(old))).getnames()
names=sorted(set(names+['controllers/config.go','frontend/src/components/SettingsCard.jsx','services/quota_schedule_test.go']))
source=Path(sys.argv[1]); buf=io.BytesIO()
with tarfile.open(fileobj=buf,mode='w',format=tarfile.GNU_FORMAT) as archive:
 for name in names:
  data=(source/name).read_bytes(); info=tarfile.TarInfo(name);info.size=len(data);info.mode=0o644;info.mtime=0;archive.addfile(info,io.BytesIO(data))
data=gzip.compress(buf.getvalue(),mtime=0)
s=s.replace(old,'\n'.join(textwrap.wrap(base64.b64encode(data).decode(),76)))
s=re.sub(r"OVERLAY_SHA256='[^']+'", "OVERLAY_SHA256='"+hashlib.sha256(data).hexdigest()+"'",s)
s=s.replace('每月 2 日北京时间 00:00 重置','默认每月 1 日北京时间 00:00 重置，可在系统设置选择 1–31 日')
p.write_text(s,encoding='utf-8',newline='\n')
print('Bundled',len(names),'files;',hashlib.sha256(data).hexdigest())
