class dc_gdash::config {

  $whisper_root = $dc_gdash::params::whisper_root

  file { '/var/www/gdash/config/gdash.yaml':
    owner   => root,
    group   => www-data,
    content => template('dc_gdash/gdash.yaml.erb'),
    require => Vcsrepo['gdash_github'],
  }

  @@dns_resource { "gdash.${::domain}/CNAME":
      rdata => $::fqdn,
  }

}
