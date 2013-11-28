# After initial bring up of the puppet master and the dependencies
# e.g. postgres and puppetdb, connect to puppetdb and install the
# foreman smart proxy
class dc_profile::puppet_master_post_bootstrap {

  include dc_profile::base
  include dc_profile::foreman_puppet_proxy

  class { '::puppetdb::master::config':
    puppet_service_name => 'apache2',
    puppetdb_server     => 'puppetdb.sal01.datacentred.co.uk',
    puppetdb_port       => '8081',
  }

}

