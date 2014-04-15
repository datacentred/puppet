# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "dcdevbox" 

  # TODO: Box versioning
  #config.vm.box_check_update = true
  #config.vm.box_version = 1.0.0

  # Virtualbox Configuration
  config.vm.provider "virtualbox" do |virtualbox, override|
    override.vm.box_url = "http://vboxes.sal01.datacentred.co.uk/latest-virtualbox"
  end

  # VMWare Fusion Configuration
  config.vm.provider "vmware_fusion" do |vmware, override|
    override.vm.box_url = "http://vboxes.sal01.datacentred.co.uk/latest-fusionbox"
  end

  # Puppet provisioner
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path    = "vagrant"
    puppet.module_path       = "modules"
    puppet.hiera_config_path = "vagrant/hiera.yaml"
    puppet.options           = "--verbose "
    puppet.facter            = {
                                 "environment" => "production",
                                 "is_vagrant" => "true",
                               }
  end
end
