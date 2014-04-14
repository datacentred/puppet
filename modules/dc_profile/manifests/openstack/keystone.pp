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

  $keystone_db_pw = hiera(keystone_db_pw)
  $keystone_db_host = hiera(keystone_db_host)
  $os_service_tenant = hiera(os_service_tenant)
  $os_region = hiera(os_region)

  class { '::keystone':
    require        => Dc_mariadb::Db['keystone'],
    verbose        => true,
    catalog_type   => 'sql',
    admin_token    => hiera(keystone_admin_uuid),
    sql_connection => "mysql://keystone:${keystone_db_pw}@${keystone_db_host}/keystone",
  }

  # Adds the admin credential to keystone.
  class { '::keystone::roles::admin':
    email          => hiera(sysmailaddress),
    password       => hiera(keystone_admin_pw),
    service_tenant => $os_service_tenant,
  }

  # Installs the service user endpoint.
  class { '::keystone::endpoint':
    public_url   => "http://${::fqdn}:5000",
    internal_url => "http://${::fqdn}:5000",
    admin_url    => "http://${::fqdn}:35357",
    region       => $os_region,
  }

  # Glance bits
  keystone_user { 'glance':
    ensure   => present,
    enabled  => true,
    password => hiera(keystone_glance_password),
    email    => hiera(sysmailaddress),
    tenant   => $os_service_tenant,
  }
  keystone_user_role { "glance@${os_service_tenant}":
    ensure => present,
    roles  => 'admin',
  }
  keystone_service { 'glance':
    ensure      => present,
    type        => 'image',
    description => 'Glance Image Service',
  }
  Keystone_endpoint <<| tag == 'glance_endpoint' |>>

  # Nova bits
  keystone_user { 'nova':
    ensure   => present,
    enabled  => true,
    password => hiera(keystone_nova_password),
    email    => hiera(sysmailaddress),
    tenant   => $os_service_tenant,
  }
  keystone_user_role { "nova@${os_service_tenant}":
    ensure => present,
    roles  => 'admin',
  }
  keystone_service { 'nova':
    ensure      => present,
    type        => 'compute',
    description => 'Nova Compute Service',
  }
  keystone_service { 'nova_ec2':
    ensure      => present,
    type        => 'ec2',
    description => 'EC2 Service',
  }
  Keystone_endpoint <<| tag == 'nova_endpoint' |>>

  # Neutron bits
  keystone_user { 'neutron':
    ensure   => present,
    enabled  => true,
    password => hiera(keystone_neutron_password),
    email    => hiera(sysmailaddress),
    tenant   => $os_service_tenant,
  }
  keystone_user_role { "neutron@${os_service_tenant}":
    ensure  => present,
    roles   => 'admin',
  }
  keystone_service { 'neutron':
    ensure      => present,
    type        => 'network',
    description => 'OpenStack Networking Service',
  }
  Keystone_endpoint <<| tag == 'neutron_endpoint' |>>

  exported_vars::set { 'keystone_host':
    value => $::fqdn,
  }

  # Set up DC admin users as admins in the admin tenant
  $dcadminhash = hiera(admins)
  $dcadmins = keys($dcadminhash)
  keystone_user { $dcadmins:
    ensure   => present,
    enabled  => true,
    password => $dcadminhash[$title]['pass'],
    tenant   => 'admin',
  }
  keystone_user_role { $dcadmins:
    ensure => present,
    roles  => admin,
  }

  # Icinga monitoring
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
    email    => hiera(sysmailaddress),
    tenant   => 'icinga',
  }
  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact['dc_hostgroup_keystone']

}
