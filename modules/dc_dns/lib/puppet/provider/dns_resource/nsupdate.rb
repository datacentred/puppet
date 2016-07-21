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

# SRV records return the target
class Resolv::DNS::Resource::IN::SRV
  def to_rdata
    @target.to_s
  end
end

# MX records return the exchange
class Resolv::DNS::Resource::IN::MX
  def to_rdata
    @exchange.to_s
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

  # Translate the record type to the correct class
  def typeclass(type)
    tcmap = {
      'A'     => Resolv::DNS::Resource::IN::A,
      'PTR'   => Resolv::DNS::Resource::IN::PTR,
      'CNAME' => Resolv::DNS::Resource::IN::CNAME,
      'MX'    => Resolv::DNS::Resource::IN::MX,
      'SRV'   => Resolv::DNS::Resource::IN::SRV,
    }
    raise ArgumentError, 'dns_resource::nsupdate.typeclass invalid type' unless tcmap.keys.include?(type)
    tcmap[type]
  end

  # Get the server to connect to
  def server
    '127.0.0.1'
  end

  public

  # Initial setup stuff
  def initialize(value={})
    super(value)
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
      Array(rdata).each_with_index do |exchange, index|
        preference = Array(resource[:preference])[index]
        nsupdate("server #{server}
                  update add #{name} #{ttl} MX #{preference} #{exchange}
                  send")
      end
    when 'SRV'
      Array(rdata).each_with_index do |target, index|
        port = Array(resource[:port])[index]
        weight = Array(resource[:weight])[index]
        priority = Array(resource[:priority])[index]
        nsupdate("server #{server}
                  update add #{name} #{ttl} SRV #{priority} #{weight} #{port} #{target}
                  send")
      end
    else
      nsupdate("server #{server}
                update add #{name} #{ttl} #{type} #{Array(rdata).first}
                send")
    end
  end

  # Destroy an existing DNS resource
  def destroy
    name, type = resource[:name].split('/')
    case type
    when 'MX'
      @dnsres.each do |res|
        preference = res.preference
        target = res.to_rdata
        nsupdate("server #{server}
                  update delete #{name} MX #{preference} #{target}.
                  send")
      end
    when 'SRV'
      @dnsres.each do |res|
        priority = res.priority
        weight = res.weight
        port = res.port
        target = res.to_rdata
        nsupdate("server #{server}
                  update delete #{name} SRV #{priority} #{weight} #{port} #{target}
                  send")
      end
    else
      rdata = @dnsres.to_rdata
      nsupdate("server #{server}
                update delete #{name} #{type} #{rdata}
                send")
    end
  end

  # Determine whether a DNS resource exists
  def exists?
    name, type = resource[:name].split('/')
    # Create the resolver, pointing to the nameserver
    r = Resolv::DNS.new(:nameserver => server)
    # Do the look-up
    begin
      @dnsres = r.getresources(name, typeclass(type))
    rescue Resolv::ResolvError
      return false
    end
    # MX and SRV lookups will return empty arrays
    if @dnsres.is_a? Array
      return false if @dnsres.empty?
    end
    # The record exists!
    return true
  end

  def rdata
    Array(@dnsres).map(&:to_rdata)
  end

  def rdata=(value)
    destroy
    create
  end

  def ttl
    Array(@dnsres).first.ttl.to_s
  end

  def ttl=(value)
    destroy
    create
  end

  def port
    Array(@dnsres).map(&:port).map{|x| x ? x.to_s : '0' }
  end

  def port=(value)
    destroy
    create
  end

  def priority
    Array(@dnsres).map(&:priority).map{|x| x ? x.to_s : '0' }
  end

  def priority=(value)
    destroy
    create
  end

  def weight
    Array(@dnsres).map(&:weight).map{|x| x ? x.to_s : '0' }
  end

  def weight=(value)
    destroy
    create
  end

  def preference
    Array(@dnsres).map(&:preference).map{|x| x ? x.to_s : '0' }
  end

  def preference=(value)
    destroy
    create
  end

end
