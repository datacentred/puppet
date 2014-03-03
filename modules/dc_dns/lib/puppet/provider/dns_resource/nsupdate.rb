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

  commands :dig      => 'dig',
           :hostname => 'hostname'

  private

  # Run a command script through nsupdate
  def nsupdate(cmd)
    IO.popen('nsupdate -k /etc/bind/rndc.key 2>&1', "r+") do |io|
      io.puts(cmd)
      io.close_write
      raise RuntimeError unless io.gets == nil
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
    domain = hostname('-d')[0..-2]
    axfr = dig('@127.0.0.1', domain, 'AXFR')
    records = Array.new
    axfr.split("\n").each do |line|
      tok = line.split
      if tok.length >= 5 and tok[3] =~ /^(A|PTR|CNAME)$/
        rdata = (tok[4][-1, 1] == '.') ? tok[4][0..-2] : tok[4]
        records << new(:name   => "#{tok[0][0..-2]}/#{tok[3]}",
                       :ensure => :present,
                       :rdata  => rdata,
                       :ttl    => tok[1])
      end
    end
    records
  end

  def self.prefetch(resources)
    records = instances
    resources.keys.each do |name|
      if provider = records.find{ |record| record.name == name }
        resources[name].provider = provider
      end
    end
  end

  # Create a new DNS resource
  def create
    name, type = resource[:name].split('/')
    rdata = resource[:rdata]
    ttl = resource[:ttl]
    nsupdate("server 127.0.0.1
              update add #{name}. #{ttl} #{type} #{rdata}
              send")
    @property_hash[:name] = resource[:name]
    @property_hash[:ensure] = :present
    @property_hash[:rdata] = resource[:rdata]
    @property_hash[:ttl] = resource[:ttl]
  end

  # Destroy an existing DNS resource
  def destroy
    name, type = resource[:name].split('/')
    nsupdate("server 127.0.0.1
              update delete #{name}. #{type}
              send")
    @property_hash.clear
  end

  # Determine whether a DNS resource exists
  def exists?
    @property_hash[:ensure] == :present
  end

  mk_resource_methods

  def rdata=(value)
    @property_hash[:rdata] = value
    @property_flush[:rdata] = value
  end

  def ttl=(value)
    @property_hash[:ttl] = value
    @property_flush[:ttl] = value
  end

  def flush
    if ! @property_flush.empty?
      create
    end
    @property_hash = resource.to_hash
  end

end
