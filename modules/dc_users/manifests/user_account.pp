#
define dc_users::user_account (
  $hash => undef,
) {

  user { "dc_users::user_account ${title}":
    ensure     => present,
    name       => $title,
    password   => $hash[$title]['pass'],
    uid        => $hash[$title]['uid'],
    gid        => $hash[$title]['gid'],
    shell      => '/bin/bash',
    managehome => true,
  } ->
  file { "/home/${title}/.ssh":
    ensure => directory,
    owner  => $hash[$title]['uid'],
    group  => $hash[$title]['gid'],
    mode   => '0700',
  } ->
  ssh_authorized_key { "dc_users::user_account ${title}":
    ensure => present,
    name   => $title,
    user   => $title,
    type   => 'ssh-rsa',
    key    => $hash[$title]['sshkey'],
  }

}
