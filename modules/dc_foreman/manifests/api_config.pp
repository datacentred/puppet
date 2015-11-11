# Class dc_foreman::api_config
# Configures API connectivity
class dc_foreman::api_config (
  $foreman_url,
  $foreman_view_api_pw,
  $foreman_view_api_user,
){

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/usr/local/lib/python2.7/dist-packages/dc_foreman.py':
    ensure => file,
    source => 'puppet:///modules/dc_foreman/dc_foreman.py'
  }

  file { '/usr/local/etc/foreman_api.config':
    ensure  => file,
    content => template('dc_foreman/foreman_api_config.erb'),
  }

}
