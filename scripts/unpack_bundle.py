from pathlib import Path
import base64,hashlib,io,re,sys,tarfile
s=Path('install-quota.sh').read_text(encoding='utf-8')
data=base64.b64decode(s.split("<<'FREEGFW_QUOTA_SOURCE'\n",1)[1].split('\nFREEGFW_QUOTA_SOURCE',1)[0])
assert hashlib.sha256(data).hexdigest()==re.search(r"OVERLAY_SHA256='([^']+)'",s)[1]
with tarfile.open(fileobj=io.BytesIO(data)) as archive: archive.extractall(sys.argv[1],filter='data')
