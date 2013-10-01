class profile::users {

include userlist

	group { "sysadmin":
		ensure => present,
		gid => 1000,
	}

	realize (
		Users-virtual::Localuser["mattj"],
	)

	realize (
		Users-virtual::Localuser["nick"],
	)
	
}

