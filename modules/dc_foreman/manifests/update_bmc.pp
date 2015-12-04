# Class dc_foreman::update_bmc
class dc_foreman::update_bmc (
  $foreman_url,
  $foreman_update_bmc_pw,
  $foreman_update_bmc_user,
  $bmc_network,
  $bmc_user,
  $bmc_password,
){

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  ensure_packages(['python-requests'])

  file { '/usr/local/bin/update_bmc_interface.py':
    ensure => file,
    source => 'puppet:///modules/dc_foreman/update_bmc_interface.py',
    mode   => '0755',
  }

  file { '/usr/local/lib/python2.7/dist-packages/dc_foreman.py':
    ensure => file,
    source => 'puppet:///modules/dc_foreman/dc_foreman.py'
  }

  file { '/usr/local/etc/update_bmc.config':
    ensure  => file,
    content => template('dc_foreman/update_bmc_config.erb'),
  }

  runonce { 'update_bmc_interface':
    command    => '/usr/local/bin/update_bmc_interface.py',
    persistent => true,
    require    => [File['/usr/local/etc/update_bmc.config'], File['/usr/local/bin/update_bmc_interface.py'], File['/usr/local/lib/python2.7/dist-packages/dc_foreman.py']]
  }

}
