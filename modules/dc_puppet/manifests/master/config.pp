#
class dc_puppet::master::config {

  include dc_puppet::params
  $dir            = $dc_puppet::params::dir
  $envdir         = $dc_puppet::params::envdir
  $production_env = "${envdir}/production"

  # Install git, repo and clone default environments
  contain dc_puppet::master::git
  # Install the xmpp bot to monitor for pull requests
  contain dc_puppet::master::err
  # Install foreman bits and bobs
  contain dc_puppet::master::foreman
  # Install nfs mounts
  contain dc_puppet::master::exports
  # Install backups
  contain dc_puppet::master::backup
  # Install exported variables
  contain exported_vars

  # puppet user needs access to these folders
  file { '/var/lib/puppet/reports':
    ensure  => directory,
    owner   => 'puppet',
    group   => 'puppet',
    recurse => true,
  }

  # Install hiera configuration file and notify the apache/
  # passenger service of the change to force a restart
  file { "${dir}/hiera.yaml":
    content => template('dc_puppet/master/hiera.yaml'),
    mode    => '0644',
    owner   => 'puppet',
    group   => 'puppet',
    notify  => Service[$dc_puppet::params::master_service],
  }

  # This bit basically turns bits on and off in puppet.conf
  case $::puppetmaster_stage {
    # Phase 1, stand alone, no Puppet DB or Foreman
    1, default: {
    }
    # Phase 2, puppetdb on line
    2: {
      $storeconfigs   = true
    }
    # Phase 3, fully integrated
    undef: {
      $storeconfigs   = true
      $reports        = true
      $external_nodes = "${dc_puppet::params::dir}/node.rb"
      # Now puppet DB is up spin up stuff which uses store configs
      contain dc_puppet::master::icinga
    }
  }

  concat_fragment { 'puppet.conf+30-master':
    content => template('dc_puppet/master/puppet.conf-master.erb'),
  }

  dc_external_fact::fact { 'puppetmaster_stage':
    value => $::puppetmaster_stage,
  }
}
