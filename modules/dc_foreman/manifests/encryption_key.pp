# == Class: dc_foreman::encryption_key
#
# Manage the encryption key shared across instances to secure password data
#
class dc_foreman::encryption_key {

  $encryption_key = $dc_foreman::encryption_key

  Class['::foreman::install'] ->

  file { '/etc/foreman/encryption_key.rb':
    ensure  => file,
    owner   => 'foreman',
    group   => 'foreman',
    mode    => '0640',
    content => template('dc_foreman/encryption_key.rb.erb'),
  }

}
