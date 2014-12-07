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
    lsyncd_config_content => template($conf_template),
    lsyncd_logdir_owner   => $dc_tftp::tftp_sync_user,
    lsyncd_logdir_group   => $dc_tftp::tftp_sync_group,
    require               => Sshkeys::Create_key[ $dc_tftp::tftp_sync_user ],
  }

}
