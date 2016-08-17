require 'ipaddr'

module Puppet::Parser::Functions
  newfunction(:foreman_primary_ipaddress, :type => :rvalue) do |args|

    interfaces = lookupvar('foreman_interfaces') || []

    interfaces.each do |interface|
      return interface['ip'] if interface['primary']
    end

    lookupvar('::ipaddress')

  end
end
