class dc_pcs::netservices::corosync_config {

  cs_primitive { 'net_services_vip':
    primitive_class => 'ocf',
    primitive_type  => 'IPaddr2',
    provided_by     => 'heartbeat',
    parameters      => { 'ip'       => $dc_pcs::netservices::net_services_vip, 'cidr_netmask' => '24', 'nic' => 'eth2' },
    operations      => { 'monitor'  => { 'interval'                      => '10s' } },
  }

  cs_primitive { 'net_services_drbd':
    primitive_class => 'ocf',
    primitive_type  => 'drbd',
    provided_by     => 'linbit',
    parameters      => { 'drbd_resource' => 'net_services' },
    operations      => {
      'monitor'       => [
        {'interval' => '29s', 'role' => 'Master', },
        {'interval' => '31s', 'role' => 'Slave', },
      ],
    },
    promotable  => true,
    ms_metadata => { 'master-max' => '1', 'master-node-max' => '1', 'clone-max' => '2', 'clone-node-max' => '1', 'notify' => 'true' },
  }

  cs_primitive { 'net_services_drbd_fs':
    primitive_class => 'ocf',
    primitive_type  => 'Filesystem',
    provided_by     => 'heartbeat',
    parameters      => { 'device'    => $dc_pcs::netservices::drbd_device, 'directory' => '/drbd/net_services', 'fstype' => 'ext4' },
    require         => Cs_primitive['net_services_drbd'],
  }

  cs_group { 'net_services_drbd_group':
    primitives => [ 'net_services_vip', 'net_services_drbd_fs' ],
    require   => [ Cs_primitive['net_services_vip'], Cs_primitive['net_services_drbd_fs'] ],
  }

  cs_colocation { 'net_services_drbd_fs_colo':
    primitives => [ 'ms_net_services_drbd:Master', 'net_services_drbd_fs' ],
    require    => [ Cs_primitive['net_services_drbd'], Cs_primitive['net_services_drbd_fs'] ],
  }

  cs_order { 'master_before_fs':
    first   => 'ms_net_services_drbd:promote',
    second  => 'net_services_drbd_fs:start',
    require => [ Cs_primitive['net_services_drbd'], Cs_primitive['net_services_drbd_fs'] ],
  }

}
