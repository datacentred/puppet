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
#
# Excludes can be specified as facts e.g. FACTER_excludes=a,b,c to facilitate
# bootstrapping e.g. things like icinga2 which require exported resources to
# provision cleanly cannot be run until puppetdb is bootstrapped.
$classes = hiera_array('classes')
$hiera_excludes = hiera_array('excludes', [])
if $::excludes {
  $facter_excludes = split($::excludes, ',')
} else {
  $facter_excludes = []
}
$all_excludes = union($facter_excludes, $hiera_excludes)
$includes = delete($classes, $all_excludes)
include $includes
