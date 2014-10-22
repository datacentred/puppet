# Class: dc_graphite
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
class dc_graphite (
  $graphite_db_pw,
  $graphite_secret_key,
  $graphite_db_user,
  $graphite_db_host,
  $graphite_db_name,
  $graphite_link_path,
  $graphite_manage_cname,
  $graphite_manage_db,
  $graphite_webapp_name,
  $mysql_pw,
){

  include apache

  # Another hack as the Graphite module we're using is hardcoded to install
  # everything under /opt, so link it to where we need it
  file { $graphite_link_path:
    ensure => directory,
  }

  file { '/opt/graphite':
    ensure  => link,
    target  => $graphite_link_path,
    require => File[$graphite_link_path],
  }

  class { '::graphite':
    gr_aggregator_line_interface => '0.0.0.0',
    gr_aggregator_line_port      => '2023',
    gr_web_server                => 'none',
    gr_timezone                  => 'GB-Eire',
    gr_apache_24                 => true,
    secret_key                   => $graphite_secret_key,
    gr_max_cache_size            => inf,
    gr_max_updates_per_second    => inf,
    gr_max_creates_per_minute    => inf,
    gr_enable_udp_listener       => true,
    gr_enable_carbon_aggregator  => false,
    gr_django_db_engine          => 'django.db.backends.mysql',
    gr_django_db_name            => $graphite_db_name,
    gr_django_db_user            => $graphite_db_user,
    gr_django_db_password        => $graphite_db_pw,
    gr_django_db_host            => "${graphite_db_host}.${::domain}",
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

  apache::vhost { 'graphite':
    servername                  => "${graphite_webapp_name}.${::domain}",
    docroot                     => '/opt/graphite/webapp',
    headers                     => 'Set Access-Control-Allow-Origin "*"',
    port                        => 80,
    wsgi_application_group      => '%{GLOBAL}',
    wsgi_daemon_process         => 'graphite',
    wsgi_daemon_process_options => {
      processes          => '5',
      threads            => '5',
      display-name       => '%{GROUP}',
      inactivity-timeout => '120',
    },
    wsgi_import_script          => '/opt/graphite/conf/graphite.wsgi',
    wsgi_import_script_options  => {
      process-group     => 'graphite',
      application-group => '%{GLOBAL}',
    },
    wsgi_process_group          => graphite,
    wsgi_script_aliases         => { '/' => '/opt/graphite/conf/graphite.wsgi' },
  }

  if $graphite_manage_db == true {
    class { '::dc_mariadb':
      maria_root_pw => $mysql_pw,
    }
    contain 'dc_mariadb'

    dc_mariadb::db { 'graphite':
      user     => $graphite_db_user,
      password => $graphite_db_pw,
      host     => "${::hostname}.${::domain}",
      grant    => ['ALL'],
      require  => Class['::dc_mariadb'],
    }
  }

  if $graphite_manage_cname == true {
    # Add an appropriate CNAME RR
    @@dns_resource { "graphite.${::domain}/CNAME":
      rdata => $::fqdn,
    }
  }

}
