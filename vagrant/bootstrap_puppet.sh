#!/bin/bash
# Bootstrap the vagrant puppetdb server

# Exit if the following file exists
test -f /root/.provisioned && exit 0

# Ensure we've got the latest APT caches
apt-get update

# Allow autosigning
echo '*.vagrant.dev' > /etc/puppet/autosign.conf

# Ensure we have the required packages installed
# Install the puppet master first to create certificates used by puppetdb
for i in puppetmaster puppetdb; do
  dpkg -s ${i} >/dev/null 2>&1 || apt-get -y install ${i}
done

# Ensure the PuppetDB service starts on (re)boot
update-rc.d puppetdb defaults

# Done provisioning
touch /root/.provisioned
