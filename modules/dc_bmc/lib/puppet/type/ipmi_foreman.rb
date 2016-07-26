# Manages Foreman's view of the IPMI interface in a platform agnostic way
#
Puppet::Type.newtype(:ipmi_foreman) do
  @doc = 'Type to manage BMC DHCP and DNS via The Foreman ENC'

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true) do
    desc 'Host FQDN'
  end

  newparam(:foreman_username) do
    desc 'Foreman user name'
  end

  newparam(:foreman_password) do
    desc 'Foreman password'
  end

  newparam(:foreman_url) do
    desc 'Foreman url'
  end

  newparam(:foreman_ssl_ca) do
    desc 'Foreman server CA'
  end

  newparam(:foreman_ssl_cert) do
    desc 'Foreman client certificate'
  end

  newparam(:foreman_ssl_key) do
    desc 'Foreman client key'
  end

  newparam(:bmc_expected_subnet) do
    desc 'Subnet we expect DHCP allocated BMC address to be on'
  end

  newproperty(:bmc_username) do
    desc 'BMC user name'
  end

  newproperty(:bmc_password) do
    desc 'BMC password'
  end

  autorequire(:package) do
    ['ipmitool', 'ruby-ipaddress', 'rubygem-ipaddress']
  end

end
