define dc_dnsbackup::backupzone ($zonename,$master){

  include dc_dnsbackup

  file { "${zonename}-backup.conf":
    ensure  => file,
    require => File['/etc/dnsbackup.conf.d'],
    path    => "/etc/dnsbackup.conf.d/${zonename}-backup.conf",
    owner   => root,
    group   => root,
    content => template('dc_dnsbackup/conf.erb'),
  }

}

