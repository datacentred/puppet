class profile::os-compute {

	package { 'nova-compute'
		ensure => installed,
	}

	package { 'genisoimage'
		ensure => installed,
	}

	package { 'quantum-plugin-openvswitch-agent'
		ensure => installed,
	}

}

