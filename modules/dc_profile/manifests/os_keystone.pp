# Provision the OpenStack Keystone component
class dc_profile::os_keystone {

  $keystone_db_pw = hiera(keystone_db_pw)
  $keystone_db_host = hiera(keystone_db_host)
  $os_service_tenant = hiera(os_service_tenant)

  class { 'keystone':
    require        => [
      Dc_repos::Virtual::Repo['local_cloudarchive_mirror'],
      Dc_mariadb::Db['keystone']
    ],
    verbose        => true,
    catalog_type   => 'sql',
    admin_token    => hiera(keystone_admin_uuid),
    sql_connection => "mysql://keystone:${keystone_db_pw}@127.0.0.1/keystone",
  }

  # Adds the admin credential to keystone.
  class { 'keystone::roles::admin':
    email          => hiera(sysmailaddress),
    password       => hiera(keystone_admin_pw),
    service_tenant => $os_service_tenant,
  }

  # Installs the service user endpoint.
  class { 'keystone::endpoint':
    public_address   => $::ipaddress,
    admin_address    => $::ipaddress,
    internal_address => $::ipaddress,
    region           => 'sal01',
  }

  # Glance bits
  keystone_user { 'glance':
    ensure   => present,
    enabled  => true,
    password => hiera(keystone_glance_password),
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

  exported_vars::set { 'keystone_host':
    value => $::fqdn,
  }
}
