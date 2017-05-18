# Class dc_openvpn::server
#
# Sets up an openvpn server with approriate firewalling and (if necessary) routing
#
class dc_openvpn::server (
  Hash $defaults,
  Hash $firewall,
) {

  include ::firewall
  include ::openvpn
  include ::network

  $endpoint = hiera_hash('dc_openvpn::endpoint')
  validate_hash($endpoint)

  $routes   = hiera_hash('dc_openvpn::routes', {})

  create_resources(firewall, $firewall['base'])
  create_resources(firewall, $firewall['allow'])
  create_resources(firewall, $firewall['log'])
  create_resources(firewall, $firewall['drop'])

  create_resources(openvpn::server, $endpoint, $defaults)

}

