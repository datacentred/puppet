class dc_motd {
  file { '/run/motd.dynamic':
    ensure => absent,
  }

  file { '/etc/motd':
    ensure  => file,
    content => template("dc_motd/motd.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
