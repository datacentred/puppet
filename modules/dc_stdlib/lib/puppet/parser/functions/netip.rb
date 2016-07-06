# Return a hash of interfaces and IP addresses based on two arguments, the
# first being the name of particular network and the second being a hash of
# network name to network ID mappings.
#
# Useful when you need to know the IP address of a NIC on a particular network.
#
# This works on the assumption that the third octet in the IPv4 address equals
# the network ID.  Also assumes that various types of virtual interfaces should
# not be included in the check.
#
require 'ipaddr'

module Puppet::Parser::Functions
  newfunction(:netip, :type => :rvalue) do |args|
    network  = args[0]
    networks = args[1]

    disallowed_interfaces = ["lo", "br", "ovs", "tap", "tun", "vir"]

    interfaces = lookupvar('interfaces').split(',')
    interfaces.reject!{|interface| interface.start_with?(*disallowed_interfaces)}

    interfaces.inject({}) do |output, interface|
      address = lookupvar("ipaddress_#{interface}")
      output[interface] = address if address && address.split('.')[2] == networks[network]
      output
    end
  end
end
