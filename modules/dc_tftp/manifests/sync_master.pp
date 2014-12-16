# Class: dc_tftp::sync_master
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
class dc_tftp::sync_master {

  include dc_tftp
  include dc_tftp::sync_user
  include ::keepalived

  # Allow Linux to bind to IPs which don't yet exist
  sysctl { 'net.ipv4.ip_nonlocal_bind':
    ensure => present,
    value  => '1',
  }

  keepalived::vrrp::script { 'check_tftp':
    script => '/usr/bin/killall -0 in.tftpd',
  }

  keepalived::vrrp::instance { 'keepalived_tftp_syncmaster':
    interface         => 'bond0',
    state             => 'MASTER',
    priority          => '150',
    virtual_router_id => $dc_tftp::virtual_router_id,
    virtual_ipaddress => [ "$dc_tftp::virtual_address/$dc_tftp::virtual_netmask" ],
    track_script      => [ 'check_tftp' ],
  }

  sshkeys::create_key { $dc_tftp::tftp_sync_user :
    home        => $dc_tftp::tftp_sync_home,
    manage_home => true,
    ssh_keytype => 'rsa',
    require     => Class['dc_tftp::sync_user'],
  }

  file { "${dc_tftp::tftp_sync_home}/.ssh/config" :
    ensure  => present,
    owner   => $dc_tftp::tftp_sync_user,
    group   => $dc_tftp::tftp_sync_group,
    mode    => '0600',
    content => template('dc_tftp/ssh_config.erb'),
    require => Sshkeys::Create_key[ $dc_tftp::tftp_sync_user ],
  }

  class { '::lsyncd':
    lsyncd_config_content => template($dc_tftp::conf_template),
    lsyncd_logdir_owner   => $dc_tftp::tftp_sync_user,
    lsyncd_logdir_group   => $dc_tftp::tftp_sync_group,
    require               => Sshkeys::Create_key[ $dc_tftp::tftp_sync_user ],
  }

  unless $::is_vagrant {
    include ::dc_nrpe::lsyncd
    include ::dc_icinga::hostgroup_lsyncd
  }

}
