# This is a bit of a hack at present, will clean it up on due course
# For posterity and humour this comment was written 12/12/2013 - SM
class dc_profile::puppetmaster {

  class { '::puppet':
    server                      => true,
    server_storeconfigs_backend => 'puppetdb',
    server_dynamic_environments => true,
    server_foreman_url          => 'https://foreman.sal01.datacentred.co.uk',
  }

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

  class { '::puppetdb::master::config':
    puppet_service_name => 'apache2',
    puppetdb_server     => 'puppetdb.sal01.datacentred.co.uk',
    puppetdb_port       => '8081',
  }

  $defined = true

}
