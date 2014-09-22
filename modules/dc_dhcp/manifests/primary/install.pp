# == Class: dc_dhcp::primary::install
#
# Install dhcp synchronisation agent and its dependencies
#
class dc_dhcp::primary::install {

  private()

  package { 'python-pyinotify':
    ensure => installed,
  } 

  file { '/usr/local/bin/dhcp_sync_agent.py':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '775',
    source => 'puppet:///modules/dc_dhcp/dhcp_sync_agent.py',
  }

  file { '/etc/init.d/dhcp_sync_agent':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '775',
    source => 'puppet:///modules/dc_dhcp/dhcp_sync_agent',
  }

}
