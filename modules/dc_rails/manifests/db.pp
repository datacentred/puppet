# Class: dc_rails::db
#
# Set up a local db server and create the app db
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
class dc_rails::db(
  $db_password = undef,
  $bundler = undef,
  $app_home = undef,
  $user = undef,
  $group = undef,
  $rails_env = undef,
) {

  class { 'dc_mariadb':
    maria_root_pw => $db_password
  } ->

  exec { 'rake db:create':
    command     => "${bundler} exec rake db:create",
    cwd         => $app_home,
    group       => $group,
    user        => $user,
    environment => ["RAILS_ENV=${rails_env}", "DB_PASSWORD='${db_password}'"],
  } ->

  exec { 'rake db:migrate':
    command     => "${bundler} exec rake db:migrate",
    cwd         => $app_home,
    group       => $group,
    user        => $user,
    environment => ["RAILS_ENV=${rails_env}", "DB_PASSWORD='${db_password}'"],
  }
}