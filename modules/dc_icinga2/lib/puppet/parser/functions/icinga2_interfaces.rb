# Generate a set of interface entries to be added to host variables in
# the form:
#
# host.vars.interfaces["eth0"] = {
#   address = "10.0.0.1"
#   mac = "00:02:00:00:00:00"
#   cidr = "10.0.0.0/24"
# }
#
# Which allows checks to applied to particular interfaces of a host
# if they meet the right criteria e.g. check a ceph componment which
# only listens on the cluster network.  Only interfaces with a OSI
# layer 3 configuration are considered.  Those wothout a MAC are
# also discarded as they are loopback or tunnel interfaces.

require 'ipaddr'

module Puppet::Parser::Functions
  newfunction(:icinga2_interfaces, :type => :rvalue) do |args|

    # Collect a list of all interfaces detected by facter
    interfaces = lookupvar('interfaces').split(',')

    output = {}
    interfaces.each do |iface|

      # Check the interface has a valid address
      address = lookupvar("ipaddress_#{iface}")
      mac = lookupvar("macaddress_#{iface}")

      next unless address and mac

      # Read the remainaing details
      network = lookupvar("network_#{iface}")
      netmask = lookupvar("netmask_#{iface}")

      # Calculate the CIDR
      prefix_len = IPAddr.new(netmask).to_i.to_s(2).count('1')
      cidr = "#{network}/#{prefix_len}"

      # Generate a key to be inserted into icinga2::object::host::vars
      key = "interfaces[\"#{iface}\"]"

      # Buffer the result
      output[key] = {
        'address' => address,
        'mac' => mac,
        'cidr' => cidr,
      }

    end

    output
  end
end
