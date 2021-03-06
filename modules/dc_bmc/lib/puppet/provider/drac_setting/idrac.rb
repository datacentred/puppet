# Heavily influenced from https://github.com/newrelic/puppet-dell

Puppet::Type.type(:drac_setting).provide(:idrac) do

  commands :racadm => '/opt/dell/srvadmin/sbin/racadm'

  def object_value
    zombie_check(racadm("getconfig", *resource_to_args).split("\n").first)
  end

  def object_value=(value)
    zombie_check(racadm("config", *resource_to_args(value)))
  end

  def resource_to_args(value=nil)
    arg_array =  ['-g', resource[:group]]
    arg_array << ['-i', resource[:object_index]] if !resource[:object_index].nil?
    arg_array << ['-o', resource[:object_name]]
    arg_array << value if !value.nil?
    arg_array.flatten
  end

  def zombie_check(racadm_output)
    if racadm_output =~ /One Instance of Local RACADM is already executing/
      raise Puppet::Error, "Failed check/set, an instance of racadm is already running"
    else
      racadm_output
    end
  end
end
