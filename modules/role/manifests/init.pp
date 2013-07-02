class role::generic {
	include profile::base
}

class role::dev inherits role::generic {
	include profile::dev
}
