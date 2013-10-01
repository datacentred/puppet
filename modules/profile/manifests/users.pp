class profile::users {

include userlist

	group { "sysadmin":
		ensure => present,
		gid => 1000,
	}

	User <| uid == '1001' |>
	
}

