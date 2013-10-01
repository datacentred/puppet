class profile::users {

include userlist

	group { "sysadmin":
		ensure => present,
		gid => 1000,
	}
	
	Users-virtual::Localuser <| gid == '1000' |>
}

