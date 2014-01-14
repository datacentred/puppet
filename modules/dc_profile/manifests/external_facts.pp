class dc_profile::external_facts {

  file { '/etc/facter/facts.d':
    ensure  => directory,
    require => File['/etc/facter'],
    owner   => root,
    group   => root
  }
  
  file { '/etc/facter':
    ensure     => directory,
    owner      => root,
    group      => root
  }

}
