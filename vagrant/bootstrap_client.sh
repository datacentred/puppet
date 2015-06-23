#!/bin/bash
# Bootstrap the vagrant puppet clients

# Exit if the following file exists
test -f /root/.provisioned && exit 0

# By default the puppet VMs have vagrant at 1000:1000 which interferes with
# our hard coded IDs.  Removing this hurdle allows testing of user account
# provisioning
userdel -rf vagrant

# Distribution-specific package considerations
if [ -f /etc/redhat-release ]; then
  yum makecache fast > /dev/null
  yum install -y puppetdb-terminus > /dev/null
  gem install --no-rdoc --no-ri hiera-eyaml > /dev/null
  sed -i '/Defaults    requiretty/d' /etc/sudoers
else
  apt-get update &> /dev/null
  for i in puppetdb-terminus; do
    dpkg -s ${i} &> /dev/null || apt-get -y install ${i} > /dev/null
  done
  for i in hiera-eyaml; do
    gem query --name ${i} --installed &> /dev/null || gem install --no-rdoc --no-ri ${i} > /dev/null
  done
fi

# Install deep_merge so hiera hash merges compile
gem install deep_merge >/dev/null

# Setup PuppetDB
cat << EOF > /etc/puppet/puppetdb.conf
[main]
server = puppetdb.$(hostname -d)
EOF

# Set up routes.yaml to ensure facts are up to date
cat <<EOF > /etc/puppet/routes.yaml
---
apply:
  catalog:
    terminus: compiler
    cache: puppetdb
  facts:
    terminus: facter
    cache: puppetdb_apply
EOF

# Clean out stale SSL certificates
find /var/lib/puppet/ssl -type f -delete

# Done provisioning
touch /root/.provisioned
