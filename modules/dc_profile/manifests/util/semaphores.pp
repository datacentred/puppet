# Class: dc_profile::util::semaphores
#
# Utility class to handle semaphore files for exec
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::util::semaphores {

  $semaphores = '/var/lib/puppet/semaphores'

  file {"${semaphores}":
    ensure  => directory,
    mode    => '0754',
    require => Package['puppet'],
  }

}
