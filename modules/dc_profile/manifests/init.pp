class dc_profile::base {

  include dc_profile::vim
  include dc_profile::admins
  include dc_profile::ntpclient
  include dc_profile::baserepos
  include dc_profile::sudoers
  include dc_profile::rootpw
  include dc_profile::sshconfig
  include dc_profile::puppet
  include dc_profile::icinga_client

}

class dc_profile::cephnode {

  include dc_profile::cephrepos

}

class dc_profile::openstack {

  include dc_profile::mysqlserver

}
