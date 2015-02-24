class dc_pcs::netservices::corosync_install {

  class { 'corosync':
    enable_secauth    => true,
    authkey_source    => 'string',
    authkey           => $dc_pcs::netservices::net_services_authkey,
    bind_address      => $ipaddress_eth2,
    multicast_address => '239.1.1.2',
    packages          => [ 'corosync', 'pacemaker', 'crmsh' ],
    set_votequorum    => true,
  }

  corosync::service { 'pacemaker':
    version => '1',
  }

  cs_property { 'stonith-enabled' :
      value => 'false',
  }

  cs_property { 'no-quorum-policy' :
      value => 'ignore',
  }

}
