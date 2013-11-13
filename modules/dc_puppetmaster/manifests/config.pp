# Perform post installation configuration tasks
class dc_puppetmaster::config {

  # Seems to collapse due to not being able to chmod
  # /var/lib/puppet/reports to 755, being owned by
  # root.  Maybe a bit agressive with the recursion
  # but what the hell, we're on a tight budget
  file { '/var/lib/puppet/reports':
    ensure  => directory,
    owner   => 'puppet',
    group   => 'puppet',
    recurse => true,
  }

}
