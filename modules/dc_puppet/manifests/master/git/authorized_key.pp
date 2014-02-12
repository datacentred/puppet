#
define dc_puppet::master::git::authorized_key (
  $hash = undef,
) {
  ssh_authorized_key { "dc_puppet::master::git::authorized_key_${title}":
    ensure => present,
    user   => 'git',
    type   => 'ssh-rsa',
    key    => $hash[$title]['key'],
  }
}
