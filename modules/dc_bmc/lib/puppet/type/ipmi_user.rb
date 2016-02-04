Puppet::Type.newtype(:ipmi_user) do
  @doc = 'Manage IPMI user accounts'

  feature :ipmitool, 'Supports ipmitool management.'
  feature :ilo, "Supports hponcfg management."

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true) do
    desc 'Username'
  end

  newproperty(:password) do
    desc 'Password'
  end

  newproperty(:callin, :required_features => :ipmitool) do
    desc 'Enable access during call-in or call back connections'
    newvalues(:false, :true)
    defaultto :true
  end

  newproperty(:link, :required_features => :ipmitool) do
    desc 'Enable IPMI link authentication'
    newvalues(:false, :true)
    defaultto :true
  end

  newproperty(:ipmi, :required_features => :ipmitool) do
    desc 'Enable IPMI messaging'
    newvalues(:false, :true)
    defaultto :true
  end

  newproperty(:privilege, :required_features => :ipmitool) do
    desc 'Privilege level'
    newvalues(:callback, :user, :operator, :administrator)
    defaultto :user
  end

  newproperty(:ilo_name, :required_features => :ilo) do
    desc 'Long username for the login'
    defaultto { @resource[:name] }
  end

  newproperty(:ilo_admin, :required_features => :ilo) do
    desc 'Administer user accounts'
    newvalues(:false, :true)
    defaultto :false
  end

  newproperty(:ilo_remote, :required_features => :ilo) do
    desc 'Remote console access'
    newvalues(:false, :true)
    defaultto :false
  end

  newproperty(:ilo_power, :required_features => :ilo) do
    desc 'Virtual power and reset'
    newvalues(:false, :true)
    defaultto :false
  end

  newproperty(:ilo_media, :required_features => :ilo) do
    desc 'Virtual media'
    newvalues(:false, :true)
    defaultto :false
  end

  newproperty(:ilo_config, :required_features => :ilo) do
    desc 'Configure iLO settings'
    newvalues(:false, :true)
    defaultto :false
  end

  autorequire(:package) do
    [ 'ipmitool', 'hponcfg' ]
  end
end
