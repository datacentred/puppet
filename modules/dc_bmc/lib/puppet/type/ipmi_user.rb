# Type to manage IPMI users on the system
#
Puppet::Type.newtype(:ipmi_user) do
  @doc = 'Manage IPMI user accounts'

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

  newproperty(:callin) do
    desc 'Enable access during call-in or call back connections'
    newvalues(:false, :true)
    defaultto :true
  end

  newproperty(:link) do
    desc 'Enable IPMI link authentication'
    newvalues(:false, :true)
    defaultto :true
  end

  newproperty(:ipmi) do
    desc 'Enable IPMI messaging'
    newvalues(:false, :true)
    defaultto :true
  end

  newproperty(:privilege) do
    desc 'Privilege level'
    newvalues(:callback, :user, :operator, :administrator)
    defaultto :user
  end

  autorequire(:package) do
    'ipmitool'
  end
end
