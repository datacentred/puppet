class profile::base {

	include profile::vim
	include profile::admins
	include profile::ntpclient
	include profile::sudoers
}

class profile::dev {

	include profile::git

}

class profile::openstack {

	include profile::mysqlserver

}
