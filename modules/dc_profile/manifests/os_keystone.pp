class dc_profile::os_keystone {

  $keystone_db_pw = hiera(keystone_db_pw)
  $keystone_db_host = hiera(keystone_db_host)

  class { 'keystone':
    require        => [ Dc_repos::Virtual::Repo['local_cloudarchive_mirror'], Dc_mariadb::Db['keystone'] ],
    verbose        => true,
    catalog_type   => 'sql',
    admin_token    => hiera(keystone_admin_uuid),
    sql_connection => "mysql://keystone:${keystone_db_pw}@127.0.0.1/keystone",
  }

  # Adds the admin credential to keystone.
  class { 'keystone::roles::admin':
    email        => hiera(sysmailaddress),
    password     => hiera(keystone_admin_pw),
  }

  # Installs the service user endpoint.
  class { 'keystone::endpoint':
    public_address   => $::ipaddress,
    admin_address    => $::ipaddress,
    internal_address => $::ipaddress,
    region           => 'sal01',
  }

  # OpenStack services get their own tenant
  keystone_tenant { 'services':
    ensure  => present,
    enabled => true,
  }

  keystone_user { 'glance':
    ensure   => present,
    enabled  => true,
    password => hiera(keystone_glance_password),
    tenant   => 'services',
  }

  exported_vars::set { 'keystone_host':
    value => $::fqdn,
  }
}
