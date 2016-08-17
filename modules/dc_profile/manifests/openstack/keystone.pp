# Class: dc_profile::openstack::keystone
#
# Provision the OpenStack Keystone component
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::keystone {

  include ::keystone
  include ::keystone::roles::admin
  include ::keystone::wsgi::apache
  include ::dc_icinga::hostgroup_keystone

  include ::sysctls

  # Ensure that the various PKI-related certificates and keys
  # are the same across all nodes running Keystone
  $keystone_signing_key  = hiera(keystone_signing_key)
  $keystone_signing_cert = hiera(keystone_signing_cert)
  $keystone_ca_key       = hiera(keystone_ca_key)

  file { [  '/etc/keystone/ssl', '/etc/keystone/ssl/certs',
            '/etc/keystone/ssl/private' ]:
    ensure => directory,
    owner  => 'keystone',
    group  => 'keystone',
  }

  file { '/etc/keystone/ssl/private/signing_key.pem':
    content => $keystone_signing_key,
    mode    => '0600',
    owner   => 'keystone',
    group   => 'keystone',
    require => Package['keystone'],
    notify  => Service['keystone'],
  }
  file { '/etc/keystone/ssl/certs/signing_cert.pem':
    content => $keystone_signing_cert,
    mode    => '0600',
    owner   => 'keystone',
    group   => 'keystone',
    require => Package['keystone'],
    notify  => Service['keystone'],
  }
  file { '/etc/keystone/ssl/private/cakey.pem':
    content => $keystone_ca_key,
    mode    => '0600',
    owner   => 'keystone',
    group   => 'keystone',
    require => Package['keystone'],
    notify  => Service['keystone'],
  }

  $_ipaddress = foreman_primary_ipaddress()

  @@haproxy::balancermember { "${::fqdn}-keystone-auth":
    listening_service => 'keystone-auth',
    server_names      => $::hostname,
    ipaddresses       => $_ipaddress,
    ports             => '5000',
    options           => 'check inter 2000 rise 2 fall 5'
  }
  @@haproxy::balancermember { "${::fqdn}-keystone-admin":
    listening_service => 'keystone-admin',
    server_names      => $::hostname,
    ipaddresses       => $_ipaddress,
    ports             => '35357',
    options           => 'check inter 2000 rise 2 fall 5'
  }

  # Distribution-specific considerations
  case $::osfamily {
    'Debian': {
      file_line { 'keystone_nofiles':
        path    => '/etc/init/keystone.conf',
        line    => 'limit nofile 4096 65536',
        require => Package['keystone'],
        before  => Service['keystone'],
      }
    }
    'RedHat': {
      file_line { 'keystone_nofiles':
        path    => '/usr/lib/systemd/system/openstack-keystone.service',
        line    => 'LimitNOFILE=65535',
        after   => 'ExecStart=/usr/bin/keystone-all',
        require => Package['keystone'],
        before  => Service['keystone'],
      }
      service { 'firewalld':
        ensure => 'stopped',
      }
      service { 'NetworkManager':
        ensure => 'stopped',
      }
    }
    default: {}
  }

  # Remove the package logrotate and install our own
  file { '/etc/logrotate.d/keystone':
    ensure => absent,
  }

  logrotate::rule { 'dc_keystone':
    path          => '/var/log/keystone/*.log',
    rotate        => 90,
    rotate_every  => 'day',
    ifempty       => false,
    delaycompress => true,
    compress      => true,
    copytruncate  => true,
  }

}
