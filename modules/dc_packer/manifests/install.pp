class dc_packer::install {

  # We want the latest and greatest stable VirtualBox packages from upstream
  include dc_repos::repolist
  realize (Dc_repos::Virtual::Repo["local_virtualbox_mirror"])

  $packer_home = "/home/packer"
  $packer_pass = hiera(packer_pass)

  file { $packer_home:
    source  => "puppet:///modules/dc_packer",
    ensure  => directory,
    replace => true,
    purge   => true,
    recurse => true,
    owner   => 'packer',
  }

  file { 'preseedme.rb':
    path    => '/home/packer/bin/preseedme.rb',
    content => template('dc_packer/preseedme.rb'),
    ensure  => file,
    owner   => 'packer',
    mode    => '0744',
  }

  file { [ "$packer_home/output", "$packer_home/http" ]:
    ensure => directory,
    owner  => 'packer',
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
