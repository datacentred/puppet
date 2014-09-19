# == Class: dc_dhcp::params
#
# dhcp synchronisation agent parameters.  Override with hiera
# data bindings
#
# === Parameters
#
# [*ssh_private_key*]
#   Full contents of the ssh private key file
#
# [*ssh_public_key*]
#   Public key portion of the ssh public key file
#
# [*secondary_dhcp_host*]
#   Hostname or IP address of the secondary dhcp server
#   to synchronise the static leases to
#
class dc_dhcp::params (
  $ssh_private_key,
  $ssh_public_key,
  $secondary_dhcp_host,
) {

  private()

}
