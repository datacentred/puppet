# Class:
#
# Installs the icinga client on a host
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# class { icinga::client: }
#
class dc_icinga::client (
  $host_tag = $::environment,
) {

  contain ::icinga::client

  ## If we have a role associated, include it in the node description
  # Note: DELETE ME when all nodes have a role
  if $::role {
    $description = $::role
  } else {
    $description = $::fqdn
  }

  @@icinga::host { $::hostname:
    ensure          => present,
    description     => $::fqdn,
    address         => foreman_primary_ipaddress(),
    use             => 'dc_host_generic',
    hostgroups      => template('dc_icinga/hostgroups.erb'),
    icon_image      => 'base/ubuntu.png',
    icon_image_alt  => 'Ubuntu 14.04 LTS (trusty)',
    notes           => $description,
    statusmap_image => 'base/ubuntu.gd2',
    vrml_image      => 'ubuntu.png',
    tag             => $host_tag,
  }

}
