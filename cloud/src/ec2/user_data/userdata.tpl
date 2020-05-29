#cloud-config
---
runcmd:
- [ apt-get, update, -y ]
- [ apt-get, install, -y, curl, wget, nginx ]
- [ wget, "https://myire.com", -O, /tmp/index.html ]
