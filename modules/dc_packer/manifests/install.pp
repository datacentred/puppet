# Class: dc_packer::install
#
# Installs the Packer binaries and the supporting DC components
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_packer::install {

  $packer_home    = '/home/packer'
  $packer_package = '0.5.2_linux_amd64.zip'

  file { $packer_home:
    ensure  => directory,
    owner   => packer,
    source  => 'puppet:///modules/dc_packer',
  }

  file {  [ "${packer_home}/bin",
            "${packer_home}/output",
            "${packer_home}/http",
          ]:
    ensure  => directory,
    recurse => true,
    owner   => 'packer',
  }

  file { 'preseedme.rb':
    ensure  => file,
    path    => "${packer_home}/bin/preseedme.rb",
    content => template('dc_packer/preseedme.rb'),
    owner   => 'packer',
    mode    => '0744',
    require => File["${packer_home}/bin"],
  }

  package { [ 'ruby1.9.3', 'virtualbox-4.3', 'unzip']:
    ensure  => installed,
  }

  exec { 'packer_binaries':
    command => "wget -q https://dl.bintray.com/mitchellh/packer/${packer_package} && unzip ${packer_package}",
    cwd     => "${packer_home}/bin",
    path    => [ '/usr/bin' ],
    require => [ File[$packer_home], Package['unzip'] ],
  }

}
