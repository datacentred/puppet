#
define dc_users::user_account (
  $hash = undef,
) {

  if $hash[$title]['ensure'] == 'absent' {
    
    # Full on deletion of everything to do with them
    exec { "userdel -r ${title}":
      onlyif => "grep ${title} /etc/passwd",
    }

  } else {

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

    dc_users::ssh_authorized_key { "${title}@${title}":
      hash => $hash,
    }

  }

}
