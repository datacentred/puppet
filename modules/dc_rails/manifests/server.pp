# Class: dc_rails::webserver
#
# Setup the webserver for a Rails server
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
class dc_rails::server {

  $user = hiera(rails::user::name)
  $password = hiera(rails::user::password)
  $group = hiera(rails::user::name)
  $db_password = hiera(dc_mariadb::maria_root_pw)
  $rails_env = 'production'
  $ruby = '2.1.2'
  $home = "/home/${user}/"
  $log_base = '/var/log/rails/'
  $run_base = '/var/run/rails/'

  include ::redis
  class { '::nginx': manage_repo => false }

  class { '::dc_mariadb': maria_root_pw => '' }

  user { $user :
    ensure     => present,
    groups     => 'sudo',
    shell      => '/bin/bash',
    managehome => true,
    home       => $home,
    password   => $password,
  } ->

  class { 'dc_rails::files':
    home      => $home,
    log_base  => $log_base,
    run_base  => $run_base,
    user      => $user,
    group     => $group,
  } ->

  class { 'dc_rails::environment':
    home     => $home,
    user     => $user,
    group    => $group,
    ruby     => $ruby,
  }

}