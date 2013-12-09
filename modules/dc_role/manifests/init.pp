class dc_role::generic {
  include dc_profile::base
}

class dc_role::dns_master inherits dc_role::generic {
  include dc_profile::dns_master
}

class dc_role::dns_slave inherits dc_role::generic {
  include dc_profile::dns_slave
}
