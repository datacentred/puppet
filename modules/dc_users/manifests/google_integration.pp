# Class: dc_users::google_integration
#
#   Class to deploy google apps integration tooling
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
class dc_users::google_integration (
  $client_id,
  $client_secret,
  $access_token,
  $refresh_token,
){

  $required_apt_packages = [ 'git', 'python-pip' ]
  $required_pip_packages = [ 'google-api-python-client', 'simplejson' ]

  ensure_packages($required_apt_packages)
  ensure_packages($required_pip_packages, {provider => 'pip', require => Package['python-pip']})

  vcsrepo { '/usr/local/bin/google_apps':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/datacentred/googleapps-directory-tools.git',
    require  => Package['git'],
  }

  file { '/usr/local/bin/google_apps/private/client_secret.json':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('dc_users/client_secret.json.erb'),
    require => Vcsrepo['/usr/local/bin/google_apps'],
  }

  file { '/usr/local/bin/google_apps/private/credential.dat':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('dc_users/credential.dat.erb'),
    require => Vcsrepo['/usr/local/bin/google_apps'],
  }

}
