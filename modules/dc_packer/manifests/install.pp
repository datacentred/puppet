class dc_packer::install {

  $packer_home = '/home/packer'
  $packer_pass = hiera(packer_pass)

  file { $packer_home:
    ensure  => directory,
    source  => 'puppet:///modules/dc_packer',
    recurse => true,
    owner   => 'packer',
  }

  file { 'preseedme.rb':
    ensure  => file,
    path    => "$packer_home/bin/preseedme.rb",
    content => template('dc_packer/preseedme.rb'),
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

  package { 'virtualbox-4.3':
    ensure => installed,
  }

}
