# foreman_managed_interfaces.rb
#
# Returns a list of interfaces managed by foreman
# and not enslaved by a bonded interface.
#

# Foreman is **** and non-deterministic which introduces
# random changes in puppet code, so deterministically order
# hash output
def recurse_order(o)
  case o
  # Arrays are un ordered, haven't seen these move... yet
  when Array
    o.map{ |x| recurse_order(x) if x.respond_to? :each }
  # Hash entries move all over the place so order based on key
  when Hash
    tmp = {}
    o.each do |k,v|
      if v.respond_to? :each
        tmp[k] = recurse_order(v)
      else
        tmp[k] = v
      end
    end
    Hash[tmp.sort]
  # Other things ignore
  else
    o
  end
end

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
    recurse_order(mi.reject { |x| bs.include? x['identifier'] })
  end
end
