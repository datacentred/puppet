# Installation of Graphite, specifying a MySQL backend for storage
class dc_profile::graphite {

  $graphite_db_pw = hiera(graphite_db_pw)
  $graphite_secret_key = hiera(graphite_secret_key)

  # Bit of a hack as the Graphite module we're using doesn't install
  # these automatically despite handling the various MySQL-related
  # parameters for us...
  package { ['mysql-client', 'python-mysqldb']:
    ensure => installed,
  }

  # Another hack as the Graphite module we're using is hardcoded to install
  # everything under /opt.  We dedicate the lion's share of available disk
  # to /var, so that's the preference in this case.
  file { '/var/opt/graphite':
    ensure => directory,
  }

  file { '/opt/graphite':
    ensure  => 'link',
    target  => '/var/opt/graphite',
    require => File['/var/opt/graphite'],
  }

  class { '::graphite':
    gr_aggregator_line_interface => '0.0.0.0',
    gr_aggregator_line_port      => '2023',
    gr_web_server                => 'apache',
    secret_key                   => $graphite_secret_key,
    gr_max_cache_size            => 1024,
    gr_enable_udp_listener       => true,
    gr_enable_carbon_aggregator  => true,
    gr_django_db_engine          => 'django.db.backends.mysql',
    gr_django_db_name            => 'graphite',
    gr_django_db_user            => 'graphite',
    gr_django_db_password        => $graphite_db_pw,
    gr_django_db_host            => 'db0.sal01.datacentred.co.uk',
    gr_django_db_port            => 3306,
    require                      => [ Package['mysql-client', 'python-mysqldb'], File['/opt/graphite'], ]
  }

  contain 'graphite'

}
