# Class: dc_tftp::sync_slave
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
class dc_tftp::sync_slave {

  include dc_tftp
  include dc_tftp::sync_user
  include ::keepalived

  sshkeys::set_authorized_key {"${dc_tftp::tftp_sync_user}@${dc_tftp::sync_master} to ${dc_tftp::tftp_sync_user}@${::hostname}":
    local_user  => $dc_tftp::tftp_sync_user,
    remote_user => "${dc_tftp::tftp_sync_user}@${dc_tftp::sync_master}.${::domain}",
    home        => $dc_tftp::tftp_sync_home,
  }

  # Allow Linux to bind to IPs which don't yet exist
  sysctl { 'net.ipv4.ip_nonlocal_bind':
    ensure => present,
    value  => '1',
  }

  keepalived::vrrp::script { 'check_tftp':
    script => '/usr/bin/killall -0 in.tftpd',
  }

  keepalived::vrrp::instance { 'keepalived_tftp_syncslave':
    interface         => 'eth0',
    state             => 'BACKUP',
    priority          => '100',
    virtual_router_id => $dc_tftp::virtual_router_id,
    virtual_ipaddress => [ "$dc_tftp::virtual_ipaddress/29" ],
    track_script      => [ 'check_tftp' ],
  }

}
