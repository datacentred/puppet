class dc_profile::keystone_mariadb {

  $keystone_mariaroot_pw = hiera(keystone_mariaroot_pw)

  class { 'dc_mariadb':
    maria_root_pw       => $keystone_mariaroot_pw,
  }

}
