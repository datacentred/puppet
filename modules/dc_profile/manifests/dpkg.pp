class dc_profile::dpkg {

# Remove multiarch support
  file { '/etc/dpkg/dpkg.cfg.d/multiarch':
    ensure => absent,
  }

}

