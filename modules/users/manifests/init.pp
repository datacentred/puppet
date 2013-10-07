class users::virtual {
  define account ($uid,$gid,$pass="",$sshkey="") {

    user { $title:
      ensure     => 'present',
      uid        => $uid,
      gid        => $gid,
      shell      => '/bin/bash',
      home       => "/home/$title",
      comment    => $realname,
      password   => $pass,
      managehome => true,
    }

    if ( $sshkey != "" ) {
      ssh_authorized_key { $title:
        ensure  => 'present',
        type    => 'ssh-rsa',
        key     => "$sshkey",
        user    => "$title",
        require => File["/home/$title/.ssh"],
        name    => "$title",
      }
    }

    file { "/home/$title/.ssh":
      path    => "/home/$title/.ssh",
      ensure  => directory,
      owner   => "$uid",
      group   => "$gid",
      mode    => '0700',
      require => User["$title"],
    }
  }
}
