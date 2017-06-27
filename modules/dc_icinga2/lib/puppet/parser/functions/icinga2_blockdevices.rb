# Generate a set of block device entries to be added to host variables in
# the form:
#
# host.vars.blockdevices["sda"] = {
#   path = "/dev/sda",
# }
#
# Which allows checks to applied to particular block devices of a host
# if they meet the right criteria

def pretty_size(s)
  c = 0
  while s > 1000
    s /= 1000
    c += 1
  end
  "#{s}#{' KMGTPEZY'[c]}B"
end

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

      # Figure out the device size to add more context
      size = lookupvar("blockdevice_#{device}_size")

      # Buffer the result
      output[key] = {
        'path' => '/dev/' + device_clean,
        'model' => lookupvar("blockdevice_#{device}_model"),
        'size' => size,
        'pretty_size' => pretty_size(size),
      }

    end

    output
  end
end
