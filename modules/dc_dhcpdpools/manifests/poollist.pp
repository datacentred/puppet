# This is the class containing the list of unrealized virtual dhcp pools
# don't use this class directly.

class dc_dhcpdpools::poollist {

include dc_dhcpdpools::virtual

# SAL01 networks
# Office

  @dc_dhcpdpools::virtual::dhcpdpool { 'office-wired':
    network => '10.10.8.0',
    mask    => '255.255.255.0',
    range   => '10.10.8.16 10.10.8.247',
    gateway => '10.10.8.1',
    tag     => 'vlan8'
  }

  @dc_dhcpdpools::virtual::dhcpdpool { 'office-voice':
    network => '10.10.10.0',
    mask    => '255.255.255.0',
    range   => '10.10.10.16 10.10.10.247',
    gateway => '10.10.10.1',
    tag     => 'vlan10'
  }

  @dc_dhcpdpools::virtual::dhcpdpool { 'office-wireless':
    network => '10.10.12.0',
    mask    => '255.255.255.0',
    range   => '10.10.12.16 10.10.12.247',
    gateway => '10.10.12.1',
    tag     => 'vlan12'
  }

  @dc_dhcpdpools::virtual::dhcpdpool { 'office-guestwireless':
    network => '10.10.14.0',
    mask    => '255.255.255.0',
    range   => '10.10.14.16 10.10.14.247',
    gateway => '10.10.14.1',
    tag     => 'vlan14'
  }

# Network Management

  @dc_dhcpdpools::virtual::dhcpdpool { 'network-management':
    network => '10.10.32.0',
    mask    => '255.255.255.0',
    range   => '10.10.32.16 10.10.32.247',
    gateway => '10.10.32.1',
    tag     => 'vlan32'
  }

# Environmental Monitoring

  @dc_dhcpdpools::virtual::dhcpdpool { 'environmental-monitoring':
    network => '10.10.36.0',
    mask    => '255.255.255.0',
    range   => '10.10.36.16 10.10.36.247',
    gateway => '10.10.36.1',
    tag     => 'vlan36'
  }

# Rack Infrastructure

  @dc_dhcpdpools::virtual::dhcpdpool { 'rack-infrastructure':
    network => '10.10.40.0',
    mask    => '255.255.255.0',
    range   => '10.10.40.16 10.10.40.247',
    gateway => '10.10.40.1',
    tag     => 'vlan40'
  }

# Storage Internal

  @dc_dhcpdpools::virtual::dhcpdpool { 'storage-internal':
    network => '10.10.96.0',
    mask    => '255.255.255.0',
    range   => '10.10.96.16 10.10.96.247',
    gateway => '10.10.96.1',
    tag     => 'vlan96'
  }

# IPMI

  @dc_dhcpdpools::virtual::dhcpdpool { 'ipmi':
    network => '10.10.128.0',
    mask    => '255.255.255.0',
    range   => '10.10.128.16 10.10.128.247',
    gateway => '10.10.128.1',
    tag     => 'vlan128'
  }

# Compute Internal

  @dc_dhcpdpools::virtual::dhcpdpool { 'compute-internal':
    network => '10.10.160.0',
    mask    => '255.255.255.0',
    range   => '10.10.160.16 10.10.160.247',
    gateway => '10.10.160.1',
    tag     => 'vlan160'
  }

# Platform Services

  @dc_dhcpdpools::virtual::dhcpdpool { 'platform-services':
    network => '10.10.192.0',
    mask    => '255.255.255.0',
    range   => '10.10.192.16 10.10.192.247',
    gateway => '10.10.192.1',
    tag     => 'vlan192'
  }
}
