# Class: dc_rally::config
#
# Creates a DataCentred deployment and installs Tempest
#
class dc_rally::config (
  $auth_url     = $dc_rally::params::auth_url,
  $rallyhome    = $dc_rally::params::rallyhome,
  $username     = $dc_rally::params::username,
  $password     = undef
) inherits dc_rally::params {

  file { "${rallyhome}/dcdev.json":
    ensure  => file,
    content => template('dc_rally/dcdev.json.erb'),
    require => Vcsrepo["${rallyhome}/rally"],
  } ~>
  exec { 'create_deployment':
    command => "/usr/local/bin/rally deployment create --filename ${rallyhome}/dcdev.json --name=DataCentred",
    user    => $username,
    creates => "${rallyhome}/.rally/globals",
  } ~>
  exec { 'deploy_tempest':
    command => '/usr/local/bin/rally-manage tempest install',
    user    => $username,
  }

}
