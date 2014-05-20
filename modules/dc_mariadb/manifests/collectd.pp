# Class: dc_mariadb::collectd
#
# Add monitoring configuration for collectd
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
class dc_mariadb::collectd {

  $mysql_collectd_username = 'collectd'
  $mysql_collectd_password = hiera(mariadb_collectd_pw)
  $mysql_collectd_hostname = 'localhost'

  mysql_user { "${mysql_collectd_username}@${mysql_collectd_hostname}":
    ensure        => present,
    password_hash => mysql_password($mysql_collectd_password),
    require       => Class['mysql::server::service'],
  }

  mysql_grant { "${mysql_collectd_username}@${mysql_collectd_hostname}/*.*":
    ensure     => present,
    user       => "${mysql_collectd_username}@${mysql_collectd_hostname}",
    table      => '*.*',
    privileges => [ 'REPLICATION CLIENT' ],
    require    => Mysql_user["${mysql_collectd_username}@${mysql_collectd_hostname}"],
  }

  # Add custom facts

  file { '/usr/lib/ruby/vendor_ruby/facter/mysql.rb':
    ensure  => file,
    content => template('dc_mariadb/mysql.rb.erb'),
  }

}

