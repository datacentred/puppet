# This is a bit of a hack at present, will clean it up on due course
# For posterity and humour this comment was written 12/12/2013 - SM
class dc_profile::puppetmaster {

  class { '::exported_vars': }
  contain 'exported_vars'

  class { '::puppet':
    version                     => latest,
    runmode                     => 'cron',
    server                      => true,
    server_storeconfigs_backend => 'puppetdb',
    server_dynamic_environments => true,
    server_foreman_url          => 'https://foreman.sal01.datacentred.co.uk',
  }
  contain 'puppet'

  class { '::foreman_proxy':
    ssl                 => true,
    puppetca            => true,
    tftp                => false,
    dhcp                => false,
    dns                 => false,
    bmc                 => false,
    register_in_foreman => false,
    use_sudoersd        => false,
  }
  contain 'foreman_proxy'

  class { '::puppetdb::master::config':
    puppet_service_name => 'apache2',
    puppetdb_server     => 'puppetdb.sal01.datacentred.co.uk',
    puppetdb_port       => '8081',
    require             => Class['::puppet'],
  }
  contain 'puppetdb::master::config'

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact::Def['dc_hostgroup_puppetmaster']
  realize Dc_external_facts::Fact::Def['dc_hostgroup_foreman_proxy']

}
