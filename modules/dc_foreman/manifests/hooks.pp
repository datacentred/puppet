class dc_foreman::hooks (
  $foreman_hipchat_token,
  $foreman_hipchat_room,
  $foreman_oauth_consumer_key,
  $foreman_oauth_consumer_secret,
  $nagios_api_host,
  $nagios_api_username,
  $nagios_api_password,
) {

  $home = '/usr/share/foreman'

  package { 'python-pip':
    ensure => present,
  } ->
  package { 'python-simple-hipchat':
    ensure   => present,
    provider => 'pip',
  }

  # Install ruby bindings for API
  package { 'foreman_api':
    ensure   => 'installed',
    provider => 'gem',
  }

  File {
    owner => 'foreman',
    group => 'foreman',
    mode  => '0770',
  }

  file { ["${home}/config/hooks",
          "${home}/config/hooks/host",
          "${home}/config/hooks/host/managed",
          "${home}/config/hooks/host/managed/destroy",
          "${home}/config/hooks/host/managed/before_provision",
          "${home}/config/hooks/host/managed/after_build"
  ]:
    ensure => directory,
  }

  file { "${home}/config/hooks/host/managed/before_provision/10_hipchat.py":
    ensure  => file,
    content => template('dc_foreman/hooks/10_hipchat.py.erb'),
  }

  file { "${home}/config/hooks/host/managed/before_provision/20_enable_icinga.rb":
    ensure  => file,
    content => template('dc_foreman/hooks/20_enable_icinga.rb.erb'),
  }

  file { "${home}/config/hooks/host/managed/after_build/10_disable_icinga.rb":
    ensure  => file,
    content => template('dc_foreman/hooks/10_disable_icinga.rb.erb'),
  }

  file { "${home}/config/hooks/host/managed/destroy/10_remove_from_icinga.rb":
    ensure  => file,
    content => template('dc_foreman/hooks/10_remove_from_icinga.rb.erb'),
  }

}
