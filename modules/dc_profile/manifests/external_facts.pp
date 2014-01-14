class dc_profile::external_facts {

  file { '/etc/facter/facts.d':
    ensure     => directory,
    owner      => root,
    group      => root
  }

}
