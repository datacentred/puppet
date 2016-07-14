# Workaround for python-pip package provider being broken under RHEL
# Details: https://tickets.puppetlabs.com/browse/PUP-3829
#
class dc_profile::util::rhel_pip_fix {

  file { '/usr/bin/pip-python':
    ensure => 'link',
    target => '/usr/bin/pip',
  }

}
