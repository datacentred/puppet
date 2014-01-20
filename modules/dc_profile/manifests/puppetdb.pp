# Class for provisioning puppet db
class dc_profile::puppetdb {

  $puppetdb_pw = hiera(puppetdb_pw)

  class { '::puppetdb::server':
    ssl_listen_address => '0.0.0.0',
    database           => 'postgres',
    database_host      => 'db0.sal01.datacentred.co.uk',
    database_name      => 'puppetdb',
    database_username  => 'puppetdb',
    database_password  => $puppetdb_pw,
  }

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact::Def['dc_hostgroup_puppetdb']

}

