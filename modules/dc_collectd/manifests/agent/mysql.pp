# == Class: dc_collectd::agent::mysql
#
# Collect stats and dashboards for mysql
#
class dc_collectd::agent::mysql (
  $username,
  $password,
  $hostname,
  $databases,
) {

  include stdlib

  Class['::mysql::server'] ->

  mysql_user { "${username}@${hostname}":
    ensure        => present,
    password_hash => mysql_password($password),
  } ->

  mysql_grant { "${username}@${hostname}/*.*":
    ensure     => present,
    user       => "${username}@${hostname}",
    table      => '*.*',
    privileges => [ 'REPLICATION CLIENT', 'SHOW DATABASES' ],
  }

  Collectd::Plugin::Mysql::Database {
    host     => $hostname,
    username => $username,
    password => $password,
  }

  # Generate the collectd config
  create_resources(collectd::plugin::mysql::database, $databases)

}
