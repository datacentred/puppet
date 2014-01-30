class dc_profile::keystone_db {

  $keystone_db_pw = hiera(keystone_db_pw)

  # Keystone database
  postgresql::server::db { 'keystone':
    user     => 'keystone',
    password => $keystone_db_pw,
    grant    => 'all',
    require  => Class['::postgresql::server'],
  }
  contain postgresql::server

}
