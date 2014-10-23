class dc_motd {
  file { '/etc/issue':
    ensure => absent,
  }

  file { '/etc/issue.net':
    ensure => absent,
  }

  file { '/etc/update-motd.d':
    ensure  => directory,
    recurse => true,
    purge   => true,
  }

  file { '/etc/motd':
    ensure  => file,
    content => template('dc_motd/motd.erb')
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
