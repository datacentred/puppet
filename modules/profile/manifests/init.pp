class profile::base {

	include profile::vim
	include profile::ntpclient
	include profile::localrepo
}

class profile::dev {

	include profile::git

}

class profile::openstack {

	include profile::cloudarchive

}
