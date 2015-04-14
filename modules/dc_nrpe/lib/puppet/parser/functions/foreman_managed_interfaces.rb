# foreman_managed_interfaces.rb
#
# Returns a list of interfaces managed by foreman
# and not enslaved by a bonded interface.
#
module Puppet::Parser::Functions
  newfunction(:foreman_managed_interfaces, :type => :rvalue) do |args|
    ifaces = lookupvar('::foreman_interfaces') || []
    # Get list of managed interfaces
    mi = ifaces.select { |x| x['managed'] }
    # Get list of bond interfaces
    bi = mi.select { |x| x['type'] == 'Bond' }
    # Get list of bond slaves
    bs = bi.inject([]) { |x, y| x + y['attached_devices'].split(',') }
    # Get list of managed interfaces which aren't bond slaves
    mi.select { |x| ! bs.include? x['identifier'] }
  end
end
