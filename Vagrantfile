# -*- mode: ruby -*-
# vi: set ft=ruby :

# Ensure everyone is running a consistent vagrant version
Vagrant.require_version '~> 1.7.2'

Vagrant.configure('2') do |config|
  config.vm.box              = 'datacentred/ubuntu-trusty64-puppet'
  config.vm.box_version      = '0.1.4'
  config.vm.box_check_update = true

  # Use landrush for DNS resolution
  config.landrush.enabled = true

  # Recurse all DNS queries via ns0/ns1 for now
  config.landrush.upstream '10.10.192.250'
  config.landrush.upstream '10.10.192.251'

  # Give every guest private networking
  config.vm.network :private_network, type: :dhcp

  # Setup a dedicated PuppetDB for storedconfigs
  config.vm.define 'puppetdb' do |box|
    box.vm.hostname = 'puppetdb.vagrant.dev'
    box.vm.synced_folder '.', '/vagrant', :disabled => true
    box.vm.provision 'shell', path: 'vagrant/bootstrap_puppetdb.sh'
  end

  # Environment specific boxes (defined in .vagrantuser)
  config.user.boxes.each do |name, options|
    config.vm.define name.to_s do |box|
      box.vm.hostname = "#{name.to_s}.vagrant.dev"

      # Allow DHCP IP to be manually overriden
      if options.has_key?(:ip)
        config.vm.network :private_network, ip: options.ip
      else
        config.vm.network :private_network, type: :dhcp
      end

      # Virtualbox Provider
      box.vm.provider 'virtualbox' do |virtualbox, override|
        virtualbox.cpus   = options.has_key?(:cpus) ? options.cpus.to_i : 2
        virtualbox.memory = options.has_key?(:memory) ? options.memory.to_i : 1024
        virtualbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end

      # VMware Fusion Provider
      box.vm.provider 'vmware_fusion' do |vmware, override|
        vmware.vmx['numvcpus'] = options.has_key?(:cpus) ? options.cpus.to_i : 2
        vmware.vmx['memsize']  = options.has_key?(:memory) ? options.memory.to_i : 1024
      end

      # Provision the box
      box.vm.provision 'shell', path: 'vagrant/bootstrap_client.sh'
      box.vm.provision 'puppet' do |puppet|
        puppet.manifest_file     = 'site.pp'
        puppet.module_path       = 'modules'
        puppet.hiera_config_path = 'vagrant/hiera.yaml'

        puppet.facter = {
          'is_vagrant'   => true,
          'vagrant_role' => options.has_key?(:puppet_class) ? options.puppet_class.to_s : 'dc_role',
        }

        puppet.options = [
          '--verbose',
          '--storeconfigs',
          '--storeconfigs_backend puppetdb',
        ]
      end
    end
  end
end
