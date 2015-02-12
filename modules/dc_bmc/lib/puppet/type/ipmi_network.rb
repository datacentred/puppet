Puppet::Type.newtype(:ipmi_network) do

  @doc = "Configure NETWORK for IPMI."

  ensurable

  newparam(:name) do
    desc 'The ip address of the IPMI interface'
    isnamevar
    validate do |value|
      unless value =~ /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/
        raise ArgumentError, "ipmi_network::name #{value} invalid. " +
                             "Should be a valid ip address. " + 
                             "Check if 'ipmitool lan print' " + 
                             "gives you a valid ip address."
      end
    end
  end

  newparam(:username) do
    desc 'The username for the IPMI interface'
  end

  newparam(:password) do
    desc 'The password for the IPMI interface'
  end

  newparam(:dhcp) do
    desc "Whether to use DHCP or not"
    defaultto true
  end

  newparam(:enable_vlan) do
    desc "Whether the interface is in a VLAN or not"
    defaultto false
  end

  newparam(:channel) do
    desc 'The IPMI channel number'
    defaultto 1
  end

  newproperty(:hostname) do
    desc 'The hostname of the IPMI interface'
  end

  newproperty(:ipaddress) do
    desc 'Static ip address if dhcp if false'
    validate do |value|
      unless value =~ /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/
        raise ArgumentError, 'ipmi_network::ip_address invalid. Should be a valid ip address'
      end
    end
  end

  newproperty(:subnet_mask) do
    desc 'The subnet mask if dhcp if false'
    validate do |value|
      unless value =~ /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/
        raise ArgumentError, 'ipmi_network::subnet_mask invalid. Should be a valid ip address'
      end
    end
  end

  newproperty(:default_gateway) do
    desc 'The default gateway if dhcp is false'
    validate do |value|
      unless value =~ /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/
        raise ArgumentError, 'ipmi_network::default_gateway invalid. Should be a valid ip address'
      end
    end
  end

  newproperty(:primary_dns_server) do
    desc 'The primary dns server if dhcp is false'
    validate do |value|
      unless value =~ /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/
        raise ArgumentError, 'ipmi_network::primary_dns_server invalid. Should be a valid ip address'
      end
    end
  end

  newproperty(:secondary_dns_server) do
    desc 'The secondary dns server if dhcp is false'
    validate do |value|
      unless value =~ /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/
        raise ArgumentError, 'ipmi_network::secondary_dns_server invalid. Should be a valid ip address'
      end
    end
  end

  newproperty(:domain_name) do
    desc 'The domain name if dhcp is false'
    validate do |value|
      unless value =~ /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/
        raise ArgumentError, 'ipmi_network::secondary_dns_server invalid. Should be a valid ip address'
      end
    end
  end

  newproperty(:vlan_tag) do
    desc 'The VLAN tag if vlan_enable is true'
    defaultto 0
  end

end
