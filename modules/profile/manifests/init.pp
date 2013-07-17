class profile::base {

	include profile::vim
	include profile::ntpclient
}

class profile::dev {

	include profile::git

}
