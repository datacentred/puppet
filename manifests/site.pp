# Define a global $PATH
Exec {
  path => [
    '/bin/',
    '/sbin/',
    '/usr/bin/',
    '/usr/sbin/',
  ],
}

# Hack for Ubuntu while puppetlabs get their shit together for 16.04
if ($::operatingsystem == 'Ubuntu') and ($::operatingsystemrelease == '15.04') {
  Service {
    provider => 'systemd',
  }
}

# Probe hiera for our class list (e.g. classy version of hiera_include)
#
# Apply an exclusion filter so that common classes can be removed from certain
# classes of hosts (e.g. all boxxen need a mail daemon, except a haproxy
# gateway, which by necessity has to listen on the SMTP port)
$classes = hiera_array('classes')
$excludes = hiera_array('excludes', [])
$includes = delete($classes, $excludes)
include $includes
