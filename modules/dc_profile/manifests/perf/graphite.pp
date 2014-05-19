# Class: dc_profile::perf::graphite
#
# Installation of Graphite, specifying a MySQL backend for storage
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::perf::graphite {

  $graphite_db_pw = hiera(graphite_db_pw)
  $graphite_secret_key = hiera(graphite_secret_key)

  # Another hack as the Graphite module we're using is hardcoded to install
  # everything under /opt.  We dedicate the lion's share of available disk
  # to /var, so that's the preference in this case.
  file { '/var/opt/graphite':
    ensure => directory,
  }

  file { '/opt/graphite':
    ensure  => link,
    target  => '/var/opt/graphite',
    require => File['/var/opt/graphite'],
  }

  class { '::graphite':
    gr_aggregator_line_interface => '0.0.0.0',
    gr_aggregator_line_port      => '2023',
    gr_web_server                => 'apache',
    gr_timezone			 => 'GB-Eire',
    gr_apache_24                 => true,
    secret_key                   => $graphite_secret_key,
    gr_max_cache_size            => inf,
    gr_max_updates_per_second    => inf,
    gr_max_creates_per_minute    => inf,
    gr_enable_udp_listener       => true,
    gr_enable_carbon_aggregator  => false,
    gr_django_db_engine          => 'django.db.backends.mysql',
    gr_django_db_name            => 'graphite',
    gr_django_db_user            => 'graphite',
    gr_django_db_password        => $graphite_db_pw,
    gr_django_db_host            => "db0.${::domain}",
    gr_django_db_port            => 3306,
    gr_storage_schemas           => [
      {
        name       => 'carbon',
        pattern    => '^carbon.*',
        retentions => '1m:5d,5m:30d',
      },
      {
        name       => 'collectd',
        pattern    => '^collectd.*',
        retentions => '1m:5d,5m:30d,15m:1y',
      },
    ],
    require                      => File['/opt/graphite'],
  }

  contain 'graphite'

  # Add an appropriate CNAME RR
  @@dns_resource { "graphite.${::domain}/CNAME":
    rdata => $::fqdn,
  }

}
