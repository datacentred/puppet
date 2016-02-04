require 'rexml/document'

# Provider for creating IPMI users on HP iLO systems
Puppet::Type.type(:ipmi_user).provide(:hponcfg) do

  has_feature :ilo

  defaultfor :bios_vendor => 'HP'
  confine :bios_vendor => 'HP'

  mk_resource_methods

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  # Translate from boolean attribute to string equivalent
  # @param value [Symbol] requested state for privilege
  # @return [String] hponcfg understood Yes/No value
  def to_enable(value)
    value == :true ? 'Yes' : 'No'
  end

  # Find the users ID
  # @param name [String] username to look for
  # @return [Integer] valid user ID or nil
  def self.get_userid(name)
    output = %x{ipmitool user list 15}.split("\n")[1..-1]
    output.each do |line|
      matches = /^(\d+)\s+#{name}/.match(line)
      next unless matches
      return Integer(matches[1])
    end
    nil
  end

  # Check if the password matches that on the system by performing
  # a user password test
  # @param userid [Integer] of the user we are testing the password agains
  # @param password [Password] of the requested user
  # @return [String] password or 'unknown' on failure
  def self.get_password(name, password)
    userid = get_userid(name)
    %x{ipmitool user test #{userid} 16 #{password} 2> /dev/null}
    $? == 0 && password || 'unknown'
  end

  # Create a list of providers populated with properties
  # @return [Array] array of providers for all instances found on the system
  def self.instances
    %x{hponcfg -w /tmp/hponcfg}
    file = File.new('/tmp/hponcfg')
    doc = REXML::Document.new(file)
    file.close
    doc.elements.collect('RIBCL/LOGIN/USER_INFO/ADD_USER') do |user|
      new(
        :name       => user.attributes['USER_LOGIN'],
        :ensure     => :present,
        :password   => :unknown,
        :ilo_name   => user.attributes['USER_NAME'],
        :ilo_admin  => user.elements['ADMIN_PRIV'].attributes['value'] == 'Y' ? :true : :false,
        :ilo_remote => user.elements['REMOTE_CONS_PRIV'].attributes['value'] == 'Y' ? :true : :false,
        :ilo_power  => user.elements['RESET_SERVER_PRIV'].attributes['value'] == 'Y' ? :true : :false,
        :ilo_media  => user.elements['VIRTUAL_MEDIA_PRIV'].attributes['value'] == 'Y' ? :true : :false,
        :ilo_config => user.elements['CONFIG_ILO_PRIV'].attributes['value'] == 'Y' ? :true : :false,
      )
    end
  end

  # For each resource defined set the provider with one of our prefeteched
  # instances if it exists.  This is the first occasion we have both the
  # resource and provider available for existing resources so use the password
  # in the type resource to check against the system, and set the property_hash
  # with the correct value if the login attempt succeeds
  # @param resources [Hash] map of resource names to resource instances
  def self.prefetch(resources)
    instances.each do |instance|
      if resource = resources[instance.name]
        instance.set({:password => get_password(instance.get(:name), resource[:password] || 'unknown')})
        resource.provider = instance
      end
    end
  end  

  # Check whether a resource exists
  # @return [Boolean] whether the resource exists or not
  def exists?
    @property_hash[:ensure] == :present
  end

  # Create a new resource.  Sets a flag in property_flush to say that
  # this resource needs to be created in #flush
  def create
    @property_hash[:ensure] = :present
    @property_flush[:ensure] = :present
  end

  # Destroy a resource.  Sets a flag in property_flush to say that
  # this resource needs to be destroyed in #flush
  def destroy
    @property_flush[:ensure] = :absent
  end

  # Flushes changes to hponcfg
  def flush
    if @property_flush[:ensure] == :present
      config = <<-EOF
      <RIBCL VERSION="2.1">
        <LOGIN USER_LOGIN="Administrator" PASSWORD="password">
          <USER_INFO MODE="write">
            <ADD_USER USER_NAME = "#{resource[:ilo_name]}" USER_LOGIN = "#{resource[:name]}" PASSWORD = "#{resource[:password]}">
              <ADMIN_PRIV value = "#{to_enable(resource[:ilo_admin])}"/>
              <REMOTE_CONS_PRIV value = "#{to_enable(resource[:ilo_remote])}"/>
              <RESET_SERVER_PRIV value = "#{to_enable(resource[:ilo_power])}"/>
              <VIRTUAL_MEDIA_PRIV value = "#{to_enable(resource[:ilo_media])}"/>
              <CONFIG_ILO_PRIV value = "#{to_enable(resource[:ilo_config])}"/>
             </ADD_USER>
          </USER_INFO>
        </LOGIN>
      </RIBCL>
      EOF
    elsif @property_flush[:ensure] == :absent
      config = <<-EOF
      <RIBCL VERSION="2.1">
        <LOGIN USER_LOGIN="Administrator" PASSWORD="password">
          <USER_INFO MODE="write">
            <DELETE_USER USER_LOGIN = "#{resource[:name]}"/>
          </USER_INFO>
        </LOGIN>
      </RIBCL>
      EOF
    else
      config = <<-EOF
      <RIBCL VERSION="2.1">
        <LOGIN USER_LOGIN="Administrator" PASSWORD="password">
          <USER_INFO MODE="write">
            <MOD_USER USER_LOGIN = "#{resource[:name]}">
              <USER_NAME value = "#{resource[:ilo_name]}"/>
              <PASSWORD value = "#{resource[:password]}"/>
              <ADMIN_PRIV value = "#{to_enable(resource[:ilo_admin])}"/>
              <REMOTE_CONS_PRIV value = "#{to_enable(resource[:ilo_remote])}"/>
              <RESET_SERVER_PRIV value = "#{to_enable(resource[:ilo_power])}"/>
              <VIRTUAL_MEDIA_PRIV value = "#{to_enable(resource[:ilo_media])}"/>
              <CONFIG_ILO_PRIV value = "#{to_enable(resource[:ilo_config])}"/>
            </MOD_USER>
          </USER_INFO>
        </LOGIN>
      </RIBCL>
      EOF
    end
    file = File.new('/tmp/hponcfg', 'w')
    file.write(config)
    file.close
    execute("hponcfg -f /tmp/hponcfg")
  end

end
