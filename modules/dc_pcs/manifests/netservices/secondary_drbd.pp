# Class: dc_pcs::netservices::secondary_drbd
#
# Configure secondary drbd for netservices
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
class dc_pcs::netservices::secondary_drbd {

  $cluster_hosts = keys($dc_pcs::netservices::cluster_pair)

  class { 'drbd': }

  drbd::resource { 'net_services':
    host1               => $cluster_hosts[0],
    host2               => $cluster_hosts[1],
    ip1                 => $dc_pcs::netservices::cluster_pair[$cluster_hosts[0]],
    ip2                 => $dc_pcs::netservices::cluster_pair[$cluster_hosts[1]],
    disk                => $dc_pcs::netservices::loopback_device,
    allow_two_primaries => true,
    disk_parameters     => {
        'fencing' => 'resource-only' },
    handlers            => {
        'fence-peer'          => '/usr/lib/drbd/crm-fence-peer.sh',
        'after-resync-target' => '/usr/lib/drbd/crm-unfence-peer.sh' },
    port                => '7789',
    device              => $dc_pcs::netservices::drbd_device,
    manage              => true,
    verify_alg          => 'sha1',
    ha_primary          => false,
    initial_setup       => false,
    automount           => false,
  }

}
