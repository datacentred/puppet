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

  $keystone_db_pw     = hiera(keystone_db_pw)
  $keystone_db_host   = hiera(keystone_db_host)
  $os_service_tenant  = hiera(os_service_tenant)
  $os_region          = hiera(os_region)
  $sysmailaddress     = hiera(sal01_internal_sysmail_address)
  $memcache_servers   = get_exported_var('', 'keystone_memcached', ['localhost:11211'])

  class { '::keystone':
    require          => Dc_mariadb::Db['keystone'],
    verbose          => true,
    catalog_type     => 'sql',
    admin_token      => hiera(keystone_admin_uuid),
    token_driver     => 'keystone.token.backends.memcache.Token',
    memcache_servers => $memcache_servers,
    sql_connection   => "mysql://keystone:${keystone_db_pw}@${keystone_db_host}/keystone",
  }

  # Adds the admin credential to keystone.
  class { '::keystone::roles::admin':
    email          => $sysmailaddress,
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

  # Set up DC admin users with the admin role in the 'openstack' tenant
  $dcadminhash = hiera(admins)
  $dcadmins = keys($dcadminhash)
  dc_profile::openstack::keystone_dcadmins { $dcadmins:
    hash   => $dcadminhash,
    tenant => 'openstack',
    role   => 'admin',
  }

  # Export variable for use by haproxy to front the Keystone
  # endpoint
  exported_vars::set { 'keystone_host':
    value => $::fqdn,
  }

  # Glance bits
  keystone_user { 'glance':
    ensure   => present,
    enabled  => true,
    password => hiera(keystone_glance_password),
    email    => $sysmailaddress,
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

  # Cinder
  keystone_user { 'cinder':
    ensure   => present,
    enabled  => true,
    password => hiera(keystone_cinder_password),
    email    => $sysmailaddress,
    tenant   => $os_service_tenant,
  }
  keystone_user_role { "cinder@${os_service_tenant}":
    ensure => present,
    roles  => 'admin',
  }
  keystone_service { 'cinder':
    ensure     => present,
    type       => 'volume',
    description => 'Cinder Volume Service',
  }
  keystone_service { 'cinderv2':
    ensure      => present,
    type        => 'volumev2',
    description => 'Cinder Volume Service V2',
  }
  Keystone_endpoint <<| tag == 'cinder_endpoint' |>>

  # Nova bits
  keystone_user { 'nova':
    ensure   => present,
    enabled  => true,
    password => hiera(keystone_nova_password),
    email    => $sysmailaddress,
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
    email    => $sysmailaddress,
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
    email    => $sysmailaddress,
    tenant   => 'icinga',
  }

  include dc_icinga::hostgroup_keystone

  # Logstash config
  include dc_profile::openstack::keystone_logstash
}
