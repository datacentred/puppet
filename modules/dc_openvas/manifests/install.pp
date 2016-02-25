# Class: dc_openvas::install
#
# Installs and configures openvas scanner
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_openvas::install {

  $openvas_packages = [ 'pnscan', 'snmp', 'netdiag', 'ike-scan', 'w3af-console', 'nikto', 'wapiti', 'sqlite3', 'gnupg2', 'nmap', 'openvas-manager', 'openvas-cli', 'openvas-gsa' ]
  $package_defaults = { require => Exec['install_openvas_scanner'] }

  ensure_packages($openvas_packages)

  file { '/var/cache/apt/openvas.seed':
    ensure => file,
    source => 'puppet:///modules/dc_openvas/openvas.seed',
  }

  # Workaround for shell environment bug in openvas-scanner postinst
  # Using package doesn't set $HOME correctly, which the postinst script needs
  runonce { 'debconf_set_selections':
    command => 'debconf-set-selections /var/cache/apt/openvas.seed',
    require => File['/var/cache/apt/openvas.seed'],
  } ->
  runonce { 'openvas_apt_update':
    command => 'apt-get update',
  } ->
  exec { 'install_openvas_scanner':
    command     => 'apt-get -y install openvas-scanner',
    environment => 'HOME=/root',
    unless      => 'dpkg -s openvas-scanner',
  }

}

