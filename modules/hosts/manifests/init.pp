# == Class: hosts
#
# Per host static host database management.  /etc/hosts is
# deleted by default only white listed host names are allowed.
#
# === Parameters
#
# [*hosts*]
#   Whitelist of allowed /etc/hosts entries as a hash of
#   IP address (v4 or v6) to a list of hostnames.  Defaults
#   to an IPv4 localhost entry to prevent horrid accidents
#
# === Notes
#
# Why don't we use puppet's native host type?  For starters
# it doesn't support multihoming, a host has a single IP
# address, so defining a host on both v4 and v6 networks
# is impossible.  As a result '::1 localhost' on 14.04 causes
# puppet ip cowardly ignore it due to the presence of
# '127.0.0.1 localhost'
#
# If you think you need to expand this class you are wrong and
# should read the documentation for ISC BIND...
#
class hosts (
  $hosts = {
    '127.0.0.1' => [
      'localhost',
    ],
  },
) {

  file { '/etc/hosts':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('hosts/hosts.erb'),
  }

}
