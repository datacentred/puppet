# lib/puppet/provider/dns_resource/nsupdate

require 'resolv'

# Make sure all resource classes default to an execption
class Resolv::DNS::Resource
  def to_rdata
    raise ArgumentError, 'Resolv::DNS::Resource.to_rdata invoked'
  end
end

# A records need to convert from a binary string to dot decimal
class Resolv::DNS::Resource::IN::A
  def to_rdata
    ary = @address.address.unpack('CCCC')
    ary.map! { |x| x.to_s }
    ary.join('.')
  end
end

# PTR records merely return the fqdn
class Resolv::DNS::Resource::IN::PTR
  def to_rdata
    @name.to_s
  end
end

# CNAME records merely return the fqdn
class Resolv::DNS::Resource::IN::CNAME
  def to_rdata
    @name.to_s
  end
end

Puppet::Type.type(:dns_resource).provide(:nsupdate) do

  # Run a command script through nsupdate
  def nsupdate(cmd)
    Open3.popen3('nsupdate -k ~/rndc-key') do |i, o, e, t|
      i.write(cmd)
      i.close_write
      raise RuntimeError, e.read unless t.value.success?
    end
  end

  # Create a new DNS resource
  def create
    name, type = resource[:name].split('/')
    nameserver = resource[:nameserver]
    rdata = resource[:rdata]
    ttl = resource[:ttl]
    nsupdate("server #{nameserver}
              update add #{name}. #{ttl} #{type} #{rdata}
              send")
  end

  # Destroy an existing DNS resource
  def destroy
    name, type = resource[:name].split('/')
    nameserver = resource[:nameserver]
    nsupdate("server #{nameserver}
              update delete #{name}. #{type}
              send")
  end

  # Determine whether a DNS resource exists
  def exists?
    name, type = resource[:name].split('/')
    # Work out which type class we are fetching
    typeclass = nil
    case type
    when 'A'
      typeclass = Resolv::DNS::Resource::IN::A
    when 'PTR'
      typeclass = Resolv::DNS::Resource::IN::PTR
    when 'CNAME'
      typeclass = Resolv::DNS::Resource::IN::CNAME
    else
      raise ArgumentError, 'dns_resource::nsupdate.exists? invalid type'
    end
    # Create the resolver, pointing to the nameserver
    r = Resolv::DNS.new(:nameserver => resource[:nameserver])
    # Attempt the lookup via DNS
    begin
      @dnsres = r.getresource(name, typeclass)
    rescue Resolv::ResolvError
      return false
    end
    # The record exists!
    return true
  end

  def rdata
    @dnsres.to_rdata
  end

  def ttl
    @dnsres.ttl.to_s
  end

  def rdata=(val)
    create
  end

  def ttl=(val)
    create
  end

end
