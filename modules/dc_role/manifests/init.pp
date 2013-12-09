class dc_role::generic {
  include dc_profile::base
}

class dc_role::hpblade {
  include dc_profile::hpblade
}

class dc_role::platformservices_master {
  include dc_profile::dns_master
  include dc_profile::dhcpd_master
  include dc_profile::tftpserver
  include dc_profile::foreman_net_proxy
}

class dc_role::dns_slave inherits dc_role::generic {
  include dc_profile::dns_slave
}
