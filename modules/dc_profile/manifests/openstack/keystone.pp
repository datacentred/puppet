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

  # OpenStack API and loadbalancer endpoint
  $osapi_public  = 'compute.datacentred.io'

  $keystone_db_host   = $osapi_public
  $keystone_db_pw     = hiera(keystone_db_pw)
  $os_service_tenant  = hiera(os_service_tenant)
  $os_region          = hiera(os_region)
  $sysmailaddress     = hiera(sal01_internal_sysmail_address)

  $osdbmq_members    = hiera(osdbmq_members)

  $rabbitmq_username = hiera(osdbmq_rabbitmq_user)
  $rabbitmq_password = hiera(osdbmq_rabbitmq_pw)
  $rabbitmq_port     = hiera(osdbmq_rabbitmq_port)
  $rabbitmq_vhost    = hiera(osdbmq_rabbitmq_vhost)

  $keystone_public_port  = '5000'
  $keystone_private_port = '35357'

  $glance_port  = '9292'
  $cinder_port  = '8776'
  $neutron_port = '9696'
  $ec2_port     = '8773'
  $nova_port    = '8774'

  $keystone_signing_key  = hiera(keystone_signing_key)
  $keystone_signing_cert = hiera(keystone_signing_cert)
  $keystone_ca_key       = hiera(keystone_ca_key)

  $management_ip = $::ipaddress

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

  class { '::keystone':
    catalog_type        => 'sql',
    admin_token         => hiera(keystone_admin_uuid),
    enable_pki_setup    => false,
    token_provider      => 'keystone.token.providers.pki.Provider',
    database_connection => "mysql://keystone:${keystone_db_pw}@${keystone_db_host}/keystone",
    rabbit_hosts        => $osdbmq_members,
    rabbit_userid       => $rabbitmq_username,
    rabbit_password     => $rabbitmq_password,
    rabbit_port         => $rabbitmq_port,
    rabbit_virtual_host => $rabbitmq_vhost,
    token_driver        => 'keystone.token.backends.memcache.Token',
    memcache_servers    => $osdbmq_members,
    public_endpoint     => "https://${osapi_public}:${keystone_public_port}",
    admin_endpoint      => "https://${osapi_public}:${keystone_private_port}",
  }

  # Adds the admin credential to keystone.
  class { '::keystone::roles::admin':
    email          => $sysmailaddress,
    password       => hiera(keystone_admin_pw),
    service_tenant => $os_service_tenant,
  }

  # Installs the service user endpoint.
  class { '::keystone::endpoint':
    public_url   => "https://${osapi_public}:${keystone_public_port}",
    internal_url => "https://${osapi_public}:${keystone_public_port}",
    admin_url    => "https://${osapi_public}:${keystone_private_port}",
    region       => $os_region,
  }

  # Add node into our loadbalancer
  @@haproxy::balancermember { "${::fqdn}-keystone-auth":
    listening_service => 'icehouse-keystone-auth',
    server_names      => $::hostname,
    ipaddresses       => $management_ip,
    ports             => '5000',
    options           => 'check inter 2000 rise 2 fall 5'
  }
  @@haproxy::balancermember { "${::fqdn}-keystone-admin":
    listening_service => 'icehouse-keystone-admin',
    server_names      => $::hostname,
    ipaddresses       => $management_ip,
    ports             => '35357',
    options           => 'check inter 2000 rise 2 fall 5'
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
  keystone_endpoint { "${os_region}/glance":
    ensure       => present,
    public_url   => "https://${osapi_public}:${glance_port}",
    admin_url    => "https://${osapi_public}:${glance_port}",
    internal_url => "https://${osapi_public}:${glance_port}",
  }

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
    ensure      => present,
    type        => 'volume',
    description => 'Cinder Volume Service',
  }
  keystone_service { 'cinderv2':
    ensure      => present,
    type        => 'volumev2',
    description => 'Cinder Volume Service V2',
  }
  keystone_endpoint { "${os_region}/cinder":
    ensure       => present,
    public_url   => "https://${osapi_public}:${cinder_port}/v1/%(tenant_id)s",
    admin_url    => "https://${osapi_public}:${cinder_port}/v1/%(tenant_id)s",
    internal_url => "https://${osapi_public}:${cinder_port}/v1/%(tenant_id)s",
  }
  keystone_endpoint { "${os_region}/cinderv2":
    ensure       => present,
    public_url   => "https://${osapi_public}:${cinder_port}/v2/%(tenant_id)s",
    admin_url    => "https://${osapi_public}:${cinder_port}/v2/%(tenant_id)s",
    internal_url => "https://${osapi_public}:${cinder_port}/v2/%(tenant_id)s",
  }

  # Nova
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
  keystone_endpoint { "${os_region}/nova":
    ensure       => present,
    public_url   => "https://${osapi_public}:${nova_port}/v2/%(tenant_id)s",
    admin_url    => "https://${osapi_public}:${nova_port}/v2/%(tenant_id)s",
    internal_url => "https://${osapi_public}:${nova_port}/v2/%(tenant_id)s",
  }
  keystone_endpoint { "${os_region}/nova_ec2":
    ensure       => present,
    public_url   => "https://${osapi_public}:${ec2_port}/services/Cloud",
    admin_url    => "https://${osapi_public}:${ec2_port}/services/Admin",
    internal_url => "https://${osapi_public}:${ec2_port}/services/Cloud",
  }

  # Neutron
  keystone_user { 'neutron':
    ensure   => present,
    enabled  => true,
    password => hiera(keystone_neutron_password),
    email    => $sysmailaddress,
    tenant   => $os_service_tenant,
  }
  keystone_user_role { "neutron@${os_service_tenant}":
    ensure => present,
    roles  => 'admin',
  }
  keystone_service { 'neutron':
    ensure      => present,
    type        => 'network',
    description => 'OpenStack Networking Service',
  }
  keystone_endpoint { "${os_region}/neutron":
    ensure       => present,
    public_url   => "https://${osapi_public}:${neutron_port}",
    admin_url    => "https://${osapi_public}:${neutron_port}",
    internal_url => "https://${osapi_public}:${neutron_port}",
  }

  # Ceilometer
  keystone_user { 'ceilometer':
    ensure   => present,
    enabled  => true,
    password => hiera(keystone_ceilometer_password),
    email    => $sysmailaddress,
    tenant   => $os_service_tenant,
  }
  keystone_user_role { "ceilometer@${os_service_tenant}":
    ensure => present,
    roles  => 'admin',
  }
  keystone_service { 'ceilometer':
    ensure      => present,
    type        => 'metering',
    description => 'Ceilometer Telemetry Service',
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
    email    => $sysmailaddress,
    tenant   => 'icinga',
  }

  unless $::is_vagrant {
    include dc_icinga::hostgroup_keystone
    if $::environment == 'production' {
      include dc_profile::openstack::keystone_logstash
    }
  }

}
