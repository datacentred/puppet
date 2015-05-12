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

  apache::vhost { "grafana.${::domain}":
    port          => '80',
    default_vhost => false,
    docroot       => '/var/lib/grafana',
    proxy_pass    => [
      {
        'path' => '/',
        'url'  => 'http://localhost:8080/'
      },
    ],
  }

  @@dns_resource { "grafana.${::domain}/CNAME":
    rdata =>  $::fqdn,
  }

}
