# == Define: dc_dnsbackup::backupzone
#
define dc_dnsbackup::backupzone ($zonename,$master){

  include dc_dnsbackup

  file { "${zonename}-${::hostname}-backup.conf":
    ensure  => file,
    require => File['/etc/dnsbackup.conf.d'],
    path    => "/etc/dnsbackup.conf.d/${zonename}-backup.conf",
    owner   => root,
    group   => root,
    content => template('dc_dnsbackup/conf.erb'),
  }

}

