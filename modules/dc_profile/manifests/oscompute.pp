class dc_profile::oscompute {

  package { 'nova-compute':
    ensure => installed,
  }

  package { 'genisoimage':
    ensure => installed,
  }

  package { 'quantum-plugin-openvswitch-agent':
    ensure => installed,
  }

}

