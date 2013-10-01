class profile::users {

include users::userlist

	group { "sysadmin":
		ensure => present,
		gid => 1000,
	}
	
	Users::Virtual::Account <| gid == '1000' |>
}

