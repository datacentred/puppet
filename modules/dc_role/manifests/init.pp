# TODO: this file is full of puppet style errors
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

class dc_role::platformservices_slave {
  include dc_profile::dns_slave
  include dc_profile::dhcpd_slave
  include dc_profile::tftpserver
}

class dc_role::platformservices_puppetmaster {
  include dc_profile::puppetmaster
}

class dc_role::platformservices_database {
  include dc_profile::coredb
  include dc_profile::coredb_mysql
}

class dc_role::platformservices_puppetdb {
  include dc_profile::puppetdb
}

class dc_role::platformservices_foreman {
  include dc_profile::foreman
}

class dc_role::platformservices_logstash {
  include dc_profile::kibana
  include dc_profile::logstash
  include dc_profile::logstashbackup
}

class dc_role::platformservices_graphite {
  include dc_profile::graphite
}
