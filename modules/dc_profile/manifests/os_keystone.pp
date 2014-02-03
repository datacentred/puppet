class dc_profile::os_keystone {

  $keystone_db_pw = hiera(keystone_db_pw)
  $keystone_db_host = hiera(keystone_db_host)

  class { 'keystone':
    require        => [ Dc_repos::Virtual::Repo['local_cloudarchive_mirror'], Dc_postgresql::Db['keystone'] ],
    verbose        => true,
    catalog_type   => 'sql',
    admin_token    => hiera(keystone_admin_uuid),
    sql_connection => "postgresql://keystone:${keystone_db_pw}@127.0.0.1/keystone",
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

}
