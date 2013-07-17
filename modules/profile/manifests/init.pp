class profile::base {

	include profile::vim
	include profile::ntpconfig
}

class profile::dev {

	include profile::git

}
