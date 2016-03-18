# Calculate a set of interfaces foreman knows about and manages in the form:
#
# host.vars.foreman_interfaces["eth0"] = {
#   address = "10.0.0.1"
#   mac = "00:02:00:00:00:00"
#   netmask = "255.255.255.0"
# }
#
# This empowers you to check that the interface configuration matches what
# the ENC expects.  Until the point the ENC updates itself to match what
# is configured on the system that is...

module Puppet::Parser::Functions
  newfunction(:icinga2_foreman_interfaces, :type => :rvalue) do |args|

    interfaces = lookupvar('foreman_interfaces')

    output = {}
    interfaces.each do |interface|

      if interface['type'] != 'Interface' or not interface['managed']
        next
      end

      # Generate a key to be inserted into icinga2::object::host::vars
      key = "foreman_interfaces[\"#{interface['identifier']}\"]"

      output[key] = {
        'address' => interface['ip'],
        'netmask' => interface['attrs']['netmask'],
        'mac' => interface['mac'],
      }

    end

    output

  end
end
