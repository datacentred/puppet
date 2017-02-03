# Parse the mountpoints facts extracting white-listed filesystem types
# and returning a hash of useful mount point information in the form
#
# host.vars.mountpoints["/"] = {
#   device     = "/dev/vda"
#   filesystem = "ext4"
# }
#

# White list specific file system types
INCLUDES = [
  'ext2',
  'ext4',
  'btrfs',
  'xfs',
]

module Puppet::Parser::Functions
  newfunction(:icinga2_mountpoints, :type => :rvalue) do |args|

    # Collect a list of all mounts detected by facter
    mountpoints = lookupvar('mountpoints')

    # Select white-listed mounts and stash away the useful parameters
    mountpoints.inject({}) do |res, mountpoint, attributes|
      if INCLUDES.include?(attributes['filesystem'])
        key = "mountpoints[\"#{mountpoint}\"]"
        res[key] = {
          'device'     => attributes['device'],
          'filesystem' => attributes['filesystem'],
        }
      end
      res
    end
  end
end
