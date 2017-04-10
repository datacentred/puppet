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

    interfaces = lookupvar('foreman_interfaces') || []

    output = {}
    interfaces.each do |interface|

      if interface['type'] != 'Interface' or not interface['managed']
        next
      end

      name = interface['identifier']

      # Generate a key to be inserted into icinga2::object::host::vars
      key = "foreman_interfaces[\"#{name}\"]"

      netmask = interface['subnet'] && interface['subnet']['mask']

      # Some hosts (e.g. VMs) don't have a subnet in foreman, therefore it doesn't
      # know the netmask.  99% of the time a guess of 255.255.255.255 is good enough
      # except on Digital Ocean, so default to what facter thinks
      unless netmask
        networking = lookupvar('networking')
        netmask = networking['interfaces'][name]['netmask']
      end

      output[key] = {
        'address' => interface['ip'],
        'netmask' => netmask,
        'mac' => interface['mac'],
      }

    end

    output

  end
end
