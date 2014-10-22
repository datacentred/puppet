class dc_motd {
  file { '/etc/motd':
    ensure  => file,
    content => template("dc_motd/motd.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
