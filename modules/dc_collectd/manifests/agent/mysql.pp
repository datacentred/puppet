# == Class: dc_collectd::agent::mysql
#
# Collect stats and dashboards for mysql
#
class dc_collectd::agent::mysql (
  $username = 'collectd',
  $password = 'collectd',
  $hostname = 'localhost',
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
    privileges => [ 'USAGE', 'REPLICATION CLIENT', 'SHOW DATABASES' ],
  }

  # Generate the collectd config
  collectd::plugin::mysql::database { $::hostname:
    host     => 'localhost',
    username => $username,
    password => $password,
  }

}
