class profile::users {

include userlist

	group { "devops":
		ensure => present,
		gid => 1000,
	}

	realize (
		Users-virtual::Localuser["mattj"],
	)
	
}

