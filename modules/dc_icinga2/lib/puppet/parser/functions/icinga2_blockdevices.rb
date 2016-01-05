# Generate a set of block device entries to be added to host variables in
# the form:
#
# host.vars.blockdevices["sda"] = {
#   path = "/dev/sda",
# }
#
# Which allows checks to applied to particular block devices of a host
# if they meet the right criteria

module Puppet::Parser::Functions
  newfunction(:icinga2_blockdevices, :type => :rvalue) do |args|

    # Collect a list of all interfaces detected by facter
    blockdevices = lookupvar('blockdevices').split(',')

    output = {}
    blockdevices.each do |device|

      # Translate the device name e.g. cciss!c0d0 into a valid object name
      # and path (i.e. '!' is illegal as an object name)
      device_clean = device.tr('!', '/')

      # Generate a key to be inserted into icinga2::object::host::vars
      key = "blockdevices[\"#{device_clean}\"]"

      # Buffer the result
      output[key] = {
        'path' => '/dev/' + device_clean
      }

    end

    output
  end
end
