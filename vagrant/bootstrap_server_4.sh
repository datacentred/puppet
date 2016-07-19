#!/bin/bash
# Bootstrap the vagrant puppetdb server

# Exit if the following file exists
test -f /root/.provisioned && exit 0

source /etc/lsb-release

# Distribution service abstraction
function start_service {
  update-rc.d $1 defaults
  if [[ ${DISTRIB_CODENAME} == 'trusty' ]]; then
    service $1 start
  else
    systemctl start $1
  fi
}

################################################################################
# Configuration
################################################################################

PACKAGES='puppetserver puppetdb postgresql'

PUPPETDB_DB='puppetdb'
PUPPETDB_DB_USER='puppetdb'
PUPPETDB_DB_PASSWORD='password'

################################################################################
# System setup
################################################################################

# Postgres doesn't like UTF8 on Xenial without this
echo > /etc/default/locale <<EOF
LANG="en_GB.utf8"
LANGUAGE="en_GB.utf8"
EOF

source /etc/default/locale

################################################################################
# Install packages
################################################################################

wget -q https://apt.puppetlabs.com/puppetlabs-release-pc1-${DISTRIB_CODENAME}.deb
dpkg -i puppetlabs-release-pc1-${DISTRIB_CODENAME}.deb

# PuppetDB will refuse to work with anything less than 9.4, so use upstream packages
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ ${DISTRIB_CODENAME}-pgdg main" > /etc/apt/sources.list.d/pgdg.list

apt-get update
for package in $PACKAGES; do
  apt-get install -y $package
done

################################################################################
# Configure the database
################################################################################

pushd /tmp > /dev/null # avoid warnings about chdir to /root
sudo -u postgres psql -c "CREATE USER ${PUPPETDB_DB_USER} WITH PASSWORD '${PUPPETDB_DB_PASSWORD}'"
sudo -u postgres psql -c "CREATE DATABASE ${PUPPETDB_DB} WITH OWNER ${PUPPETDB_DB_USER} ENCODING 'UTF8' TEMPLATE template0"
sudo -u postgres psql -c "CREATE EXTENSION pg_trgm" ${PUPPETDB_DB}
popd > /dev/null

################################################################################
# Configure puppetdb
################################################################################

# Create SSL certificates and allow access by the puppetdb user
/opt/puppetlabs/bin/puppet cert generate $(hostname -f)
usermod -a -G puppet puppetdb

cat > /etc/puppetlabs/puppetdb/conf.d/database.ini <<EOF
[database]
subname = //localhost:5432/${PUPPETDB_DB}
username = ${PUPPETDB_DB_USER}
password = ${PUPPETDB_DB_PASSWORD}
EOF

cat > /etc/puppetlabs/puppetdb/conf.d/jetty.ini <<EOF
[jetty]
port = 8080
ssl-host = 0.0.0.0
ssl-port = 8081
ssl-key = /etc/puppetlabs/puppet/ssl/private_keys/$(hostname -f).pem
ssl-cert = /etc/puppetlabs/puppet/ssl/certs/$(hostname -f).pem
ssl-ca-cert = /etc/puppetlabs/puppet/ssl/certs/ca.pem
access-log-config = /etc/puppetlabs/puppetdb/request-logging.xml
EOF

start_service puppetdb

################################################################################
# Configure puppetserver
################################################################################

echo '*.vagrant.test' > /etc/puppetlabs/puppet/autosign.conf

start_service puppetserver

# Done provisioning
touch /root/.provisioned
