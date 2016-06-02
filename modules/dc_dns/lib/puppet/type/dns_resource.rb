# lib/puppet/type/dns_resource.rb
#
# Typical Usage:
#
# dns_resource { 'melody.angel.net/A':
#   rdata => '192.168.2.1',
#   ttl   => '86400',
# }
#
# dns_resource { '1.2.168.192.in-addr.arpa/PTR':
#   rdata => 'melody.angel.net',
# }
#
# dns_resource { 'angel.net/MX':
#   rdata      => [
#     'mail0.angel.net',
#     'mail1.angel.net',
#   ],
#   preference => [
#     10,
#     20,
#   ],
# }
#
Puppet::Type.newtype(:dns_resource) do
  @doc = 'Type to manage DNS resource records'

  ensurable

  newparam(:name) do
    desc 'Unique identifier in the form "<name>/<type>"'
    validate do |value|
      name, type = value.split('/')
      case type
      when 'SRV'
        unless name =~ /^_[a-z0-9\-]+\._(tcp|udp)\..*$/
          raise ArgumentError, 'dns_resource::name invalid for SRV record'
        end
      else
        unless value =~ /^[a-z0-9\-\.\*]+\/(A|PTR|CNAME|MX)$/
          raise ArgumentError, 'dns_resource::name invalid'
        end
      end
    end
  end

  newproperty(:rdata, :array_matching => :all) do
    desc 'Relevant data e.g. IP address for an A record etc'
  end

  newproperty(:ttl) do
    desc 'The DNS record time to live, defaults to 1 day'
    defaultto '86400'
    validate do |value|
      unless value =~ /^\d+$/
        raise ArgumentError, "dns_resource::ttl invalid"
      end
    end
  end

  newproperty(:port, :array_matching => :all) do
    desc 'Port - only used for SRV records'
    validate do |value|
      unless Array(value).all? { |v| v.to_s =~ /^\d+$/ }
        raise ArgumentError, "dns_resource::port invalid"
      end
    end
  end

  newproperty(:weight, :array_matching => :all) do
    desc 'Weight - only used for SRV records'
    validate do |value|
      unless Array(value).all? { |v| v.to_s =~ /^\d+$/ }
        raise ArgumentError, "dns_resource::weight invalid"
      end
    end
  end

  newproperty(:priority, :array_matching => :all) do
    desc 'Priority - only used for SRV records'
    validate do |value|
      unless Array(value).all? { |v| v.to_s =~ /^\d+$/ }
        raise ArgumentError, "dns_resource::priority invalid"
      end
    end
  end

  newproperty(:preference, :array_matching => :all) do
    desc 'Preference - only used for MX records'
    validate do |value|
      unless Array(value).all? { |v| v.to_s =~ /^\d+$/ }
        raise ArgumentError, "dns_resource::preference invalid"
      end
    end
  end

  # nsupdate provider requires bind to be listening for
  # zone updates
  autorequire(:service) do
    'bind9'
  end

  # nsupdate provider requires nsupdate to be installed
  autorequire(:package) do
    'dnsutils'
  end

end

