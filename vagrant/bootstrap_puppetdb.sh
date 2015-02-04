#!/bin/bash
# Bootstrap the vagrant puppetdb server

# Exit if the following file exists
test -f /root/.provisioned && exit 0

# Ensure we've got the latest APT caches
apt-get update

# Ensure we have the required packages installed
for i in git puppetdb nginx; do
  dpkg -s ${i} || apt-get -y install ${i} 
done

# Clean out stale SSL certificates
find /var/lib/puppet/ssl -type f -delete

# Generate SSL certificate for PuppetDB
puppet cert generate $(hostname -f) 

# Setup SSL proxy
cat << EOF > /etc/nginx/sites-enabled/puppetdb
server {
  listen 8081;

  ssl on;
  ssl_certificate /var/lib/puppet/ssl/certs/$(hostname -f).pem;
  ssl_certificate_key /var/lib/puppet/ssl/private_keys/$(hostname -f).pem;

  location / {
    proxy_pass http://localhost:8080;
  }
}
EOF

# Restart PuppetDB & NginX
/etc/init.d/puppetdb restart > /dev/null
/etc/init.d/nginx restart > /dev/null

# Done provisioning
touch /root/.provisioned
