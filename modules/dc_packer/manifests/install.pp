class dc_packer::install {

  # We want the latest and greatest stable VirtualBox packages from upstream
  include dc_repos::repolist
  realize (Dc_repos::Virtual::Repo['local_virtualbox_mirror'])

  file { "/home/packer/":
      source  => "puppet:///modules/dc_packer",
      ensure  => directory,
      replace => true,
      purge   => true,
      recurse => true,
      owner   => "packer",
  }

  file { "/home/packer/output":
      ensure => directory,
      owner  => "packer",
  }

  # Need this for some shady Ruby script...
  package { 'ruby1.9.3':
    ensure => installed,
  }

  package { 'virtualbox-4.3' :
    ensure => installed,
    require => Dc_repos::Virtual::Repo['local_virtualbox_mirror']
  }

}
