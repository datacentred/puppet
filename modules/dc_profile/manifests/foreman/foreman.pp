# Class: dc_profile::foreman::foreman
#
# Provisions foreman with a database on another node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::foreman::foreman {

  class { '::memcached':
    max_memory => 2048,
  }

  include ::foreman
  include ::foreman::plugin::discovery
  include ::foreman::plugin::digitalocean
  include ::foreman::plugin::hooks
  include ::foreman::plugin::puppetdb
  include ::dc_foreman
  include ::dc_icinga::hostgroup_https
  include ::dc_icinga::hostgroup_foreman

  # SM: bit of a hack
  # The foreman class only populates the database if it is locally managed
  # by the foreman class, e.g. our HA solution is unsupported.  We instead
  # do this by hand.  Sadly it'll get refreshed if the configuration updates
  # but should be non-destructive
  Class['::foreman::config'] ~>

  exec { '/usr/sbin/foreman-rake db:migrate':
    user        => 'foreman',
    refreshonly => true,
  } ~>

  exec { '/usr/sbin/foreman-rake db:seed':
    user        => 'foreman',
    refreshonly => true,
  } ~>

  exec { '/usr/sbin/foreman-rake apipie:cache:index':
    user        => 'foreman',
    refreshonly => true,
  } ~>

  Class['::foreman::service']

}
