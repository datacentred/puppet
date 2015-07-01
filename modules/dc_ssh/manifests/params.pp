#
class dc_ssh::params {
  case $::osfamily {
    'Debian': {
      $service_name = 'ssh'
    }
    'RedHat': {
      $service_name = 'sshd'
    }
    default: {
      fail("${::osfamily} is unsupported.")
    }
  }
}
