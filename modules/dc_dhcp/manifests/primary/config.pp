# == Class: dc_dhcp::primary::config
#
# Configure the dhcp synchronisation agent
#
class dc_dhcp::primary::config {

  private()

  include ::dc_dhcp::params

  file { '/etc/default/dhcp_sync_agent':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    content => "SECONDARY_HOST=${dc_dhcp::params::secondary_dhcp_host}",
  }

}
