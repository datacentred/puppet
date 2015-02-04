Puppet::Type.newtype(:ipmi_radius) do

  @doc = "Configure RADIUS authentication for ipmi."

  ensurable

  newparam(:name) do
    desc 'The ip address of the ipmi interface'
    isnamevar
    validate do |value|
      unless value =~ /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/
        raise ArgumentError, "ipmi_radius::name #{value} invalid. " +
                             "Should be a valid ip address. " + 
                             "Check if 'ipmitool lan print' " + 
                             "gives you a valid ip address."
      end
    end
  end

  newparam(:username) do
    desc 'The username for the ipmi interface'
  end

  newparam(:password) do
    desc 'The password for the ipmi interface'
  end

  newproperty(:ipaddress) do
    desc "The radius server ip address"
    validate do |value|
      unless value =~ /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/
        raise ArgumentError, 'ipmi_radius::ipaddress invalid. Should be a valid ip address'
      end
    end
  end

  newproperty(:portnum) do
    desc "The RADIUS port number. Defaults to 1812"
    defaultto '1812'
    validate do |value|
      unless value =~ /\w+/ && Integer(value) > 0 && Integer(value) < 65536
        raise ArgumentError, 'ipmi_radius::portnum invalid. Should be a valid port number'
      end
    end
  end

  newproperty(:timeout) do
    desc "The RADIUS timeout. Defaults to 3"
    defaultto '3'
    validate do |value|
      unless value =~ /\w+/ 
        raise ArgumentError, 'ipmi_radius::timeout invalid. Should be an integer'
      end
    end
  end

  newproperty(:secret) do
    desc "The RADIUS secret."
  end

end
