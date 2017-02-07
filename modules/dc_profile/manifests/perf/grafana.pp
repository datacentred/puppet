# Class: dc_profile::perf::grafana
#
# Installation of Grafana dashboard
# http://grafana.org
#
# Parameters:
#
# Actions:
#
# Requires: puppet-grafana, puppetlabs-apache, archive
#
# Sample Usage:
#
class dc_profile::perf::grafana {

  include ::apache
  include ::apache::mod::status
  include ::grafana

  Class['::grafana'] ->

  apache::vhost { "grafana.${::domain}":
    port          => '80',
    default_vhost => false,
    docroot       => '/var/lib/grafana',
    docroot_owner => 'grafana',
    docroot_group => 'grafana',
    proxy_pass    => [
      {
        'path' => '/',
        'url'  => 'http://localhost:8080/'
      },
    ],
    serveraliases => [
      'grafana.datacentred.services',
    ],
  }

  # For LDAP authentication
  ca_certificate { 'puppet-ca':
    source => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
  }

  @@dns_resource { "grafana.${::domain}/CNAME":
    rdata => $::fqdn,
    tag   => $::domain,
  }

  dc_backup::dc_duplicity_job { "${::fqdn}_grafana_db" :
    source_dir     => '/var/lib/grafana/',
    backup_content => 'grafana_db',
  }

}
