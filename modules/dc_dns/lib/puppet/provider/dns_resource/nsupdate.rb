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

# MX check
class Resolv::DNS::Resource::IN::MX
  def to_rdata
    @preference.to_s
  end
end

Puppet::Type.type(:dns_resource).provide(:nsupdate) do

  private

  # Run a command script through nsupdate
  def nsupdate(cmd)
    IO.popen('nsupdate -k /etc/bind/rndc.key 2>&1', "r+") do |io|
      io.puts(cmd)
      io.close_write
      out = io.gets
      raise RuntimeError, out unless out == nil
    end
  end

  public

  # Initial setup stuff
  def initialize(value={})
    super(value)
    @property_flush = {}
  end
  # Probe the local system for all DNS resources
  def self.instances
    []
  end

  # Create a new DNS resource
  def create
    name, type = resource[:name].split('/')
    rdata = resource[:rdata]
    ttl = resource[:ttl]
    if type != 'MX'
        nsupdate("server 127.0.0.1
                  update add #{name}. #{ttl} #{type} #{rdata}
                  send")
    else
        domain = name.split('.', 2)[-1]
        nsupdate("server 127.0.0.1
                  update add #{domain} #{ttl} #{type} #{rdata} #{name}
                  send")
    end
  end

  # Destroy an existing DNS resource
  def destroy
    name, type = resource[:name].split('/')
    if type != 'MX'
        nsupdate("server 127.0.0.1
                update delete #{name}. #{type}
                send")
    else
        domain = name.split('.', 2)[-1]
        nsupdate("server 127.0.0.1
                update delete #{domain} #{type} #{rdata} #{name}.
                send")
    end
  end

  # Determine whether a DNS resource exists
  def exists?
    name, type = resource[:name].split('/')
    typeclass = nil
    # Create the resolver, pointing to the nameserver
    r = Resolv::DNS.new(:nameserver => '127.0.0.1')
    begin
        # Set the typeclass and attempt the lookup via DNS
        case type
        when 'A'
            typeclass = Resolv::DNS::Resource::IN::A
            @dnsres = r.getresource(name, typeclass)
        when 'PTR'
            typeclass = Resolv::DNS::Resource::IN::PTR
            @dnsres = r.getresource(name, typeclass)
        when 'CNAME'
            typeclass = Resolv::DNS::Resource::IN::CNAME
            @dnsres = r.getresource(name, typeclass)
        when 'MX'
            typeclass = Resolv::DNS::Resource::IN::MX
            domain = name.split('.', 2)[-1]
            mxrecords = r.getresources(domain, typeclass)
            @dnsres = mxrecords.select { |v| v.exchange.to_s == name }.first
            return false unless @dnsres
        else
            raise ArgumentError, 'dns_resource::nsupdate.exists? invalid type'
        end
    rescue Resolv::ResolvError
        return false
    end
    # The record exists!
    return true
  end

  def rdata
    @dnsres.to_rdata
  end

  def rdata=(value)
    create
  end

  def ttl
    '86400'
    #TODO: requires 14.04 LTS upgrade, ruby too old
    #@dnsres.ttl.to_s
  end

  def ttl=(value)
    create
  end

end
