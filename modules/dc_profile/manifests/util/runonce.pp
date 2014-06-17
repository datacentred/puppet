# Class: dc_profile::util::runonce
#
# Utility define to handle flag files for exec
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
define dc_profile::util::runonce ( $command, $requires = [], $refreshonly = undef ) {

  $semaphore_dir = '/var/lib/puppet/semaphores'
  $requires += [ File[$semaphore_dir] ]

  if ! defined( File[$semaphore_dir] ) {

    file { $semaphore_dir:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }

  }

  exec { $command:
    unless      => "ls ${semaphore_dir}/${title}",
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    require     => $requires,
    refreshonly => $refreshonly,
  } ~>

  file { "${semaphore_dir}/${title}":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}
