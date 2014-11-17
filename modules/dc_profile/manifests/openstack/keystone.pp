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

  contain ::keystone
  contain ::keystone::roles::admin
  contain ::keystone::endpoint

  # Data defined in the openstack_keystone role
  create_resources(keystone_user, hiera(keystone_users))
  create_resources(keystone_role, hiera(keystone_role))
  create_resources(keystone_user_role, hiera(keystone_user_roles))
  create_resources(keystone_service, hiera(keystone_services))
  create_resources(keystone_endpoint, hiera(keystone_endpoints))

  $keystone_signing_key  = hiera(keystone_signing_key)
  $keystone_signing_cert = hiera(keystone_signing_cert)
  $keystone_ca_key       = hiera(keystone_ca_key)

  # Ensure that the various PKI-related certificates and keys
  # are the same across all nodes running Keystone
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

  @@haproxy::balancermember { "${::fqdn}-keystone-auth":
    listening_service => 'icehouse-keystone-auth',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '5000',
    options           => 'check inter 2000 rise 2 fall 5'
  }
  @@haproxy::balancermember { "${::fqdn}-keystone-admin":
    listening_service => 'icehouse-keystone-admin',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '35357',
    options           => 'check inter 2000 rise 2 fall 5'
  }

  include ::dc_icinga::hostgroup_keystone

  unless $::is_vagrant {
    if $::environment == 'production' {
      include dc_profile::openstack::keystone_logstash

      # Keystone tenancy and accounts for Icinga monitoring
      keystone_tenant { 'icinga':
        ensure  => present,
        enabled => true,
      }
      keystone_user_role { 'icinga@icinga':
        ensure => present,
        roles  => admin,
      }
      keystone_user { 'icinga':
        ensure   => present,
        enabled  => true,
        password => hiera(keystone_icinga_password),
        tenant   => 'icinga',
      }
    }
  }

}
