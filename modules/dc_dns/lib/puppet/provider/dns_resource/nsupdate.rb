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

# SRV check
class Resolv::DNS::Resource::IN::SRV
  def to_rdata
    @target.to_s
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
    case type
    when 'MX'
        domain = name.split('.', 2)[-1]
        nsupdate("server 127.0.0.1
                  update add #{domain} #{ttl} #{type} #{rdata} #{name}
                  send")
    # We make an assumption that we only ever have 1 SRV record for a service
    # so priority is set to 0 as per the docs
    # this will need to change if that's no longer the case
    when 'SRV'
        port = resource[:port]
        weight = resource[:weight]
        nsupdate("server 127.0.0.1
                  update add #{name}. #{ttl} #{type} 0 #{weight} #{port} #{rdata}
                  send")
    else
        nsupdate("server 127.0.0.1
                  update add #{name}. #{ttl} #{type} #{rdata}
                  send")
    end
  end

  # Destroy an existing DNS resource
  def destroy
    name, type = resource[:name].split('/')
    case type
    when 'MX'
        domain = name.split('.', 2)[-1]
        preference = resource[:rdata]
        nsupdate("server 127.0.0.1
                update delete #{domain} #{type} #{preference } #{name}.
                send")
    # We make an assumption that we only ever have 1 SRV record for a service
    # so priority is set to 0 as per the docs
    # this will need to change if that's no longer the case
    when 'SRV'
        port = resource[:port]
        target = resource[:rdata]
        weight = resource[:weight]
        nsupdate("server 127.0.0.1
                update delete #{name}. #{type} 0 #{weight} #{port} #{target}
                send")
    else
        domain = name.split('.', 2)[-1]
        rdata = resource[:rdata]
        nsupdate("server 127.0.0.1
                update delete #{name} #{type} #{rdata}
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
        # for SRV records arbitrarily force different weights for records
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
        when 'SRV'
            weight = resource[:weight]
            port = resource[:port] 
            typeclass = Resolv::DNS::Resource::IN::SRV
            srvrecords = r.getresources(name, typeclass)
            @dnsres = srvrecords.select { |v| v.weight.to_s == weight && v.port.to_s == port }.first
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
    destroy
    create
  end

  def port
    if @dnsres.respond_to?(:port)
        @dnsres.port.to_s
    else 
        '0'
    end
  end

  def port=(value)
    destroy
    create
  end

  def weight
    if @dnsres.respond_to?(:weight)
        @dnsres.weight.to_s
    else
        '0'
    end
  end

  def weight=(value)
    destroy
    create
  end

  def ttl
    @dnsres.ttl.to_s
  end

  def ttl=(value)
    create
  end

end
