# Class: dc_profile::stronghold::firewall
#
# Common firewall settings for Stronghold nodes
#
class dc_profile::stronghold::firewall {
  include ::firewall

  firewall { '000 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }

  firewall { '000 accept all to lo interface (v6)':
    proto    => 'all',
    iniface  => 'lo',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '005 Allow inbound SSH':
    dport  => 22,
    proto  => tcp,
    action => accept,
  }

  firewall { '005 Allow inbound SSH (v6)':
    dport    => 22,
    proto    => tcp,
    action   => accept,
    provider => 'ip6tables',
  }

  firewall { '020 accept related established rules':
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }

  firewall { '020 accept related established rules (v6)':
    proto    => 'all',
    state    => ['RELATED', 'ESTABLISHED'],
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewallchain { 'INPUT:filter:IPv4':
    purge  => true,
    policy => drop,
  }

  firewallchain { 'INPUT:filter:IPv6':
    purge  => true,
    policy => drop,
  }
}
