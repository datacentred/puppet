# Class: dc_profile::net::nfsen
#
# Deploys the nfsen web interface to a server for netflow interrogation. 
# This will install apache2 with default vhosts protect with client certs. 
# It pulls in the nfdump module with the use_with_nfsen parameter. 
#
# Parameters:
#
# Actions:
#
# Requires:

# Sample Usage:
class dc_profile::net::nfsen {

  include ::nfsen
  include ::apache
  include ::apache::mod::php
  include ::apache::mod::ssl
    
  apache::vhost { "${::fqdn} non-ssl":
    servername      => $::fqdn,
    port            => 80,
    docroot         => '/var/www/html/',
    redirect_status => 'permanent',
    redirect_dest   => "https://${::fqdn}",
    before          => Class['::nfsen'],
  }

  apache::vhost { "${::fqdn} ssl":
    servername        => $::fqdn,
    port              => 443,
    docroot           => '/var/www/html/',
    ssl               => true,
    ssl_cert          => "/etc/puppetlabs/puppet/ssl/certs/${::fqdn}.pem",
    ssl_key           => "/etc/puppetlabs/puppet/ssl/private_keys/${::fqdn}.pem",
    ssl_ca            => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
    ssl_crl           => '/etc/puppetlabs/puppet/ssl/crl.pem',
    ssl_verify_client => 'require',
    ssl_verify_depth  => 1,
    before            => Class['::nfsen'],
  }

  $str = '<!DOCTYPE html><html><head><title>Holding page</title>
    </head><body>You are probably looking for
    <a href="/nfsen/"> nfsen</a></body></html>'

  file { 'default index.html':
    path    => '/var/www/html/index.html',
    content => $str,
  }

  Class['::nfdump'] -> Class['::nfsen']

}
