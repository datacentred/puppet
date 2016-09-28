# Puppet provider to manage IPMI access via ipmitool
#
Puppet::Type.type(:ipmi_user).provide(:ipmitool) do

  has_feature :ipmitool

  # Translate type enumeration to integer equivalent
  # @param value [Symbol] the privilege symbol as used by the type e.g. :user
  # @return [Integer] ipmitool representation of privilege level
  def to_priviege(value)
    map = {
      :callback      => 1,
      :user          => 2,
      :operator      => 3,
      :administrator => 4,
      :no_access     => 15,
    }
    map[value]
  end

  # Translate from ipmitool output into the symbolic equivalent
  # @param value [String] the privilege as dumped by ipmitool e.g. ADMINISTRATOR
  # @return [Symbol] internal privilege representation e.g. :user
  def self.from_privilege(value)
    map = {
      'CALLBACK'      => :callback,
      'USER'          => :user,
      'OPERATOR'      => :operator,
      'ADMINISTRATOR' => :administrator,
      'NO ACCESS'     => :no_access,
    }
    # Protect against weird output from ipmitool
    map[value] || :unknown
  end

  # Translate from boolean attribute to string equivalent
  # @param value [Symbol] requested state for callin, link or ipmi
  # @return [String] ipmitool understood on/off value
  def to_enable(value)
    value == :true ? 'on' : 'off'
  end

  # Translate from ipmitool ouput for authorization into the symbolic equivalent
  # @param value [String] state 'true' or 'false'
  # @return [Symbol] :true or :false
  def self.from_enable(value)
    value == 'true' ? :true : :false
  end

  # Parse a line from 'ipmitool user list'.  The only reliable way of doing this
  # is to split based on output formatting and some vendors echo out empty strings
  # for unallocated users
  # @param line [String] ipmitool user line
  # @return [Hash] hash of symbolic fields and their values
  def self.parse_user_line(line)
    begin
      {
        :userid    => line[0..3].to_i,
        :name      => line[4..20].rstrip,
        :callin    => from_enable(line[21..28].rstrip),
        :link      => from_enable(line[29..39].rstrip),
        :ipmi      => from_enable(line[40..50].rstrip),
        :privilege => from_privilege(line[51..-1].rstrip),
      }
    rescue NoMethodError
      raise RuntimeError, 'ipmi::ipmitool::parse_user_line: unexpected input'
    end
  end

  # Get the maximum number of users an IPMI channel supports
  # @return [Integer] maximum number of supported users
  def get_channel_max_users
    # Suppress stderr as Quanta kit barfs after the first undefined user
    Integer(/Maximum User IDs\s*:\s*(\d+)/.match(%x{ipmitool channel getaccess #{@channel} 2> /dev/null})[1])
  end

  # Allocate a free user ID
  # @name [String] name of the resource
  # @raise [RuntimeError] if no free ID is found
  # @return [Integer] first free user ID
  def allocate_id(name)
    max_users = get_channel_max_users()
    # Even though 1 is free it seems not to work on a supermicro X9??
    available_user_ids = (2..max_users).to_a
    output = %x{ipmitool user list #{@channel}}.split("\n")[1..-1]
    output.each do |line|
      fields = parse_user_line(line)
      # The user name may already exist but have no access, so try reuse that slot ID
      return fields[:userid] if fields[:name] == name
      # Remove users from the available list if they are active
      available_user_ids.delete(fields[:userid]) if fields[:privilege] != :no_access
    end
    raise RuntimeError, 'ipmi::ipmitool::allocate_id: No free user ID found' if available_user_ids.size == 0
    available_user_ids.first
  end

  # Find the LAN channel to apply permissions to
  # @return [Integer] the channel relating to LAN functionality
  def self.get_lan_channel
    # 0 = IPMB, 1-11 = Application Specific, 12-13 = Reserved, 14 = Current, 15 = System
    (1..11).to_a.each do |channel|
      begin
        output = %x{ipmitool channel info #{channel} 2> /dev/null}
      rescue Errno::ENOENT
        return nil
      end
      next unless $? == 0
      return channel if /LAN/.match(output)
    end
    nil
  end

  # Check if the password matches that on the system by performing
  # a user password test
  # @param userid [Integer] of the user we are testing the password agains
  # @param password [Password] of the requested user
  # @return [String] password or 'unknown' on failure
  def self.get_password(userid, password)
    %x{ipmitool user test #{userid} 16 #{password} 2> /dev/null}
    $? == 0 && password || 'unknown'
  end

  # Create a list of providers populated with properties
  # @return [Array] array of providers for all instances found on the system
  def self.instances
    channel = get_lan_channel
    begin
      lines = %x{ipmitool user list #{channel}}.split("\n")[1..-1]
    rescue Errno::ENOENT
      lines = []
    end
    lines.collect do |line|
      fields = parse_user_line(line)
      new(
        :ensure    => :present,
        :userid    => fields[:userid],
        :name      => fields[:name],
        :password  => 'unknown',
        :callin    => fields[:callin],
        :link      => fields[:link],
        :ipmi      => fields[:ipmi],
        :privilege => fields[:privilege],
      )
    # Treat NO ACCESS as absent
    end.select { |x| x.privilege != :no_access }
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
        # Update the propery_hash with the correct password
        # Note: The resource password will be blank when resources are being purged
        # so cater for this by supplying a dummy value
        instance.set({:password => get_password(instance.get(:userid), resource[:password] || 'unknown')})
        resource.provider = instance
      end
    end
  end

  # Check if a resource exists.  This is the first call made by all resources
  # new or existing so determine the channel that the LAN function resides on
  # @return [Boolean] whether the resource exists or not
  def exists?
    # Cache the LAN channel ID, used by create, modify and delete
    @channel = self.class.get_lan_channel()
    @property_hash[:ensure] == :present
  end

  # Create a new user resource.  Enables the user, sets the username and
  # password and configures access privileges on the LAN channel
  def create
    # Allocate a new user slot
    userid = allocate_id(resource[:name])

    # Munge any data from internal to provider format
    callin = to_enable(resource[:callin])
    ipmi = to_enable(resource[:ipmi])
    link = to_enable(resource[:link])
    privilege = to_priviege(resource[:privilege])

    # Create the user
    execute("ipmitool user enable #{userid}")
    execute("ipmitool user set name #{userid} #{resource[:name]}")
    execute("ipmitool user set password #{userid} #{resource[:password]}")
    execute("ipmitool channel setaccess #{@channel} #{userid} callin=#{callin} ipmi=#{ipmi} link=#{link} privilege=#{privilege}")

    # Update the property hash
    @property_hash = {
      :ensure    => :present,
      :userid    => userid,
      :name      => resource[:name],
      :password  => resource[:password],
      :callin    => resource[:callin],
      :link      => resource[:ipmi],
      :ipmi      => resource[:link],
      :privilege => resource[:privilege],
    }
  end

  # Destroy a user resource
  def destroy
    # Delete the user
    execute("ipmitool channel setaccess #{@channel} #{@property_hash[:userid]} callin=off ipmi=off link=off privilege=15")
    execute("ipmitool user disable #{@property_hash[:userid]}")

    # Update the property hash
    @property_hash[:ensure] = :absent
  end

  # Get the current password
  # @return [String] current password if valid or 'unknown'
  def password
    @property_hash[:password]
  end

  # Set a new password
  # @param value [String] new password value
  def password=(value)
    execute("ipmitool user set password #{@property_hash[:userid]} #{value}")
  end

  # Get the current call-in access rights
  # @return [Symbol] :true or :false
  def callin
    @property_hash[:callin]
  end

  # Set a new call-in access right
  # @param value [Symbol] :true or :false
  def callin=(value)
    execute("ipmitool channel setaccess #{@channel} #{@property_hash[:userid]} callin=#{to_enable(value)}")
  end

  # Get whether link authentication is enabled
  # @return [Symbol] :true or :false
  def link
    @property_hash[:link]
  end

  # Set whether link authentication is enabled
  # @param value [Symbol] :true or :false
  def link=(value)
    execute("ipmitool channel setaccess #{@channel} #{@property_hash[:userid]} link=#{to_enable(value)}")
  end

  # Get whether IPMI messaging is enabled
  # @return [Symbol] :true or :false
  def ipmi
    @property_hash[:ipmi]
  end

  # Set whether IPMI messaging is enabled
  # @param value [Symbol] :true or :false
  def ipmi=(value)
    execute("ipmitool channel setaccess #{@channel} #{@property_hash[:userid]} ipmi=#{to_enable(value)}")
  end

  # Get the curremt privilege limit
  # @return [Symbol] sybolic representation of privilege limits e.g. :user, :administrator
  def privilege
    @property_hash[:privilege]
  end

  # Set a new privilege limit
  # @param value [Symbol] sybolic representation of privilege limits e.g. :user, :administrator
  def privilege=(value)
    execute("ipmitool channel setaccess #{@channel} #{@property_hash[:userid]} privilege=#{to_priviege(value)}")
  end

end
