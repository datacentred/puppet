class dc_postgresql::repmgr::slave::config {

  include ::dc_postgresql::params

  file { "${dc_postgresql::params::pghome}/.ssh/config":
    ensure  => file,
    content => template('dc_postgresql/slave_ssh_config.erb'),
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0600',
  }

}
