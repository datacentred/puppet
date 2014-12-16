# == Class: ceph_billing::configure
#
class ceph_billing::configure {

  # Install the codebase from GitHub
  file { '/root/.ssh':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
  } ->

  file { '/root/.ssh/id_rsa':
    ensure  => file,
    content => $ceph_billing::deploy_key,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
  } ->

  file { '/root/.ssh/config':
    ensure  => file,
    content => "Host github.com\nStrictHostKeyChecking no",
    owner   => 'root',
    group   => 'root',
    mode    => '0640'
  } ->

  git::repo { 'blinky':
    source => $ceph_billing::source,
    path   => $ceph_billing::path,
  } ->

  # Create and populate the database
  mysql::db { $ceph_billing::db:
    user     => $ceph_billing::db_username,
    password => $ceph_billing::db_password,
  } ~>

  exec { 'python manage.py migrate --noinput':
    cwd         => $ceph_billing::path,
    refreshonly => true,
  } ->

  # Create the WSGI frontend
  apache::vhost { $fqdn:
    port                        => '443',
    docroot                     => '/var/www',
    ssl                         => true,
    ssl_cert                    => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
    ssl_key                     => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
    ssl_ca                      => '/var/lib/puppet/ssl/certs/ca.pem',
    aliases                     => [
      {
        alias => '/static/',
        path  => "${ceph_billing::path}/storage/static/",
      },
    ],
    directories                 => [
      {
        path => "${ceph_billing::path}/storage/static",
      },
      {
        path => "${ceph_billing::path}/blinky",
      },
    ],
    redirectmatch_status        => [
      'permanent',
    ],
    redirectmatch_regexp        => [
      '^/?$ /storage/',
    ],
    wsgi_daemon_process         => 'ceph.datacentred.io',
    wsgi_daemon_process_options => {
      'python-path' => $ceph_billing::path,
    },
    wsgi_process_group          => 'ceph.datacentred.io',
    wsgi_script_aliases         => {
      '/' => "${ceph_billing::path}/blinky/wsgi.py",
    },
  } ->

  # Setup the storage poller
  cron { 'ceph stat':
    command => "curl https://${::fqdn}/storage/stat/ --cacert /var/lib/puppet/ssl/certs/ca.pem",
    user    => 'root',
    minute  => '0',
  }

}
