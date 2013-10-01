class users::virtual {
	define localuser ($uid,$gid,$pass,$sshkey="") {

		user { $title:
			ensure => "present",
			uid => $uid,
			gid => $gid,
			shell => "/bin/bash",
			home => "/home/$title",
			comment => $realname,
			password => $pass,
			managehome => true,
		}

		if ( $sshkey != "" ) {
			ssh_authorized_key { $title:
				ensure 	=> "present",
				type	=> "ssh-rsa",
				key	=> "$sshkey",
				user	=> "$title",
				require => User["$title"],
				name	=> "$title",
			}
		}
	}
}
