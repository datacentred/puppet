# Class: dc_pcs::netservices::primary_drbd
#
# Configure primary drbd for net services
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_pcs::netservices::primary_drbd {

  $cluster_hosts = keys($dc_pcs::netservices::cluster_pair)

  class { 'drbd': }

  drbd::resource { 'net_services':
    host1                     => $cluster_hosts[0],
    host2                     => $cluster_hosts[1],
    ip1                       => $dc_pcs::netservices::cluster_pair[$cluster_hosts[0]],
    ip2                       => $dc_pcs::netservices::cluster_pair[$cluster_hosts[1]],
    disk                      => $dc_pcs::netservices::loopback_device,
    allow_two_primaries       => true,
    disk_parameters           => { fencing                              => 'resource-only' },
    handlers                  => {
        'fence-peer'          => '/usr/lib/drbd/crm-fence-peer.sh',
        'after-resync-target' => '/usr/lib/drbd/crm-unfence-peer.sh' },
    port                      => '7789',
    device                    => $dc_pcs::netservices::drbd_device,
    manage                    => true,
    verify_alg                => 'sha1',
    ha_primary                => true,
    initial_setup             => true,
    automount                 => false,
    notify                    => Exec['mount_first_time'],
  }

  exec { 'mount_first_time':
    command     => "mount ${dc_pcs::netservices::drbd_device} /drbd/net_services",
    refreshonly => true,
    notify      => Exec['create_initial_dirs'],
  }

  exec { 'create_initial_dirs':
    command     => 'for dir in dhcp bind tftp; do mkdir /drbd/net_services/$dir; done',
    provider    => 'shell',
    refreshonly => true,
    notify      => Exec['umount_first_time'],
  }

  exec { 'umount_first_time':
    command     => "umount ${dc_pcs::netservices::drbd_device}",
    refreshonly => true,
  }

}
