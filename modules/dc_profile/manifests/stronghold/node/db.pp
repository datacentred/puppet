# Class: dc_profile::stronghold::node::db
#
# Configure a Stronghold database node
#
class dc_profile::stronghold::node::db {
  include dc_profile::stronghold::firewall
  include ::mysql::server

  $db_user      = hiera(db_user);
  $db_password  = hiera(db_password);
  $queue_fqdn   = hiera(queue_fqdn);
  $web_fqdn     = hiera(web_fqdn);
  $queue_ip     = hiera(queue_ip);
  $web_ip       = hiera(web_ip);

  firewall { '030 allow MySQL web node':
    ensure   => 'present',
    proto    => tcp,
    action   => 'accept',
    dport    => 3306,
    source   => $web_ip,
    provider => ['iptables', 'ip6tables'],
  }

  firewall { '031 allow MySQL queue node':
    ensure   => 'present',
    proto    => tcp,
    action   => 'accept',
    dport    => 3306,
    source   => $queue_ip,
    provider => ['iptables', 'ip6tables'],
  }

  mysql_user { "${db_user}@${queue_fqdn}":
    ensure        => 'present',
    password_hash => mysql_password($db_password),
  } ->

  mysql_grant { "${db_user}@${queue_fqdn}/*.*":
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => '*.*',
    user       => "${db_user}@${queue_fqdn}",
  }

  mysql_user { "${db_user}@${web_fqdn}":
    ensure        => 'present',
    password_hash => mysql_password($db_password),
  } ->

  mysql_grant { "${db_user}@${web_fqdn}/*.*":
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => '*.*',
    user       => "${db_user}@${web_fqdn}",
  }

  mysql_user { "${db_user}@localhost":
    ensure        => 'present',
    password_hash => mysql_password($db_password),
  } ->

  mysql_grant { "${db_user}@localhost/*.*":
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => '*.*',
    user       => "${db_user}@localhost",
  }
}
