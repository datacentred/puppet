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
  include ::grafana

  package { 'toml':
    ensure   => present,
    provider => 'gem',
  }

  Package['toml'] -> Class['::grafana']

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
    require       => Class['::grafana'],
  }

  # Required for Grafana to trust the server certificate
  ca_certificate { 'puppet-ca':
    source => '/var/lib/puppet/ssl/certs/ca.pem',
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
