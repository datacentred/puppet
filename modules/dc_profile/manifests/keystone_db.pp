class dc_profile::keystone_db {

  $keystone_db_pw = hiera(keystone_db_pw)

  class { 'dc_postgresql':
  }

  dc_postgresql::db { 'keystone':
    user           => 'keystone',
    password       => $keystone_db_pw,
  }

}
