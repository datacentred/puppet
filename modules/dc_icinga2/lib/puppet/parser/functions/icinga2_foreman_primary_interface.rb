module Puppet::Parser::Functions
  newfunction(:icinga2_foreman_primary_interface, :type => :rvalue) do |args|

    interfaces = lookupvar('foreman_interfaces') || []

    interfaces.each do |interface|
      return interface['identifier'] if interface['primary']
    end

    'eth0'

  end
end
