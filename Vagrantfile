# -*- mode: ruby -*-
# vi: set ft=ruby :

PUPPET_VERSION = ENV['PUPPET_VERSION'] || '4'

UBUNTU_RELEASE = ENV['UBUNTU_RELEASE'] || 'trusty'

PROVISIONERS = {
  '4' => {
    'server' => 'vagrant/bootstrap_server_4.sh',
    'client' => 'vagrant/bootstrap_client_4.sh',
  },
}

UBUNTU_VBOXES = {
  'trusty' => 'puppetlabs/ubuntu-14.04-64-nocm',
  'xenial' => 'puppetlabs/ubuntu-16.04-64-nocm',
}

# Ensure everyone is running a consistent vagrant version
Vagrant.require_version '~> 1.8.0'

Vagrant.configure('2') do |config|
  config.vm.box              = UBUNTU_VBOXES[UBUNTU_RELEASE]
  config.vm.box_check_update = true

  # Provision using the root account.  This allows us to modify
  # the uid/gid namespaces before provisioning with puppet
  config.ssh.username = 'root'
  config.ssh.password = 'puppet'

  if Vagrant.has_plugin?("landrush")
    config.landrush.enabled = true
    config.landrush.upstream '8.8.8.8'
  end

  # Clean up old certificates from PuppetDB when a VM is destroyed
  if Vagrant.has_plugin?("vagrant-triggers")
    config.trigger.after :destroy do
        options = [ '-f', 'destroy', 'puppet' ]
        hosts = ARGV.reject!{|host| host.start_with?(*options)}
        if hosts
            hosts.each do |host|
                run "vagrant ssh puppet -c 'puppet cert clean #{host}.vagrant.test'"
            end
        end
    end
  end

  # Setup a dedicated PuppetDB for storedconfigs
  config.vm.define 'puppet' do |box|
    box.vm.network :private_network, type: :dhcp
    box.vm.hostname = 'puppet.vagrant.test'
    box.vm.synced_folder '.', '/vagrant', :disabled => true

    # Pupppet server (java) uses a fuck ton of memory
    box.vm.provider 'virtualbox' do |virtualbox, override|
      virtualbox.memory = 4096
    end
    box.vm.provider 'vmware_fusion' do |vmware, override|
      vmware.vmx['memsize'] = 4096
    end

    box.vm.provision 'shell', path: PROVISIONERS[PUPPET_VERSION]['server']
  end

  # Environment specific boxes (defined in .vagrantuser)
  # vagrant-nugrant is required for this to work
  config.user.boxes.each do |name, options|
    config.vm.define name.to_s do |box|
      box.vm.hostname = "#{name.to_s}.vagrant.test"

      # Copy the eyaml keys
      config.vm.provision 'file', source: config.user.eyaml.private_key, destination: 'private_key.pkcs7.pem'
      config.vm.provision 'file', source: config.user.eyaml.public_key,  destination: 'public_key.pkcs7.pem'

      # Allow DHCP IP to be manually overriden
      if options.has_key?(:ip)
        box.vm.network :private_network, ip: options.ip
      else
        box.vm.network :private_network, type: :dhcp
      end

      # Optionally provision RedHat
      if options.has_key?(:rhel)
        box.vm.box = 'datacentred/rhel-7.2'
        box.vm.box_url = 'https://dischord.storage.datacentred.io/vagrant/rhel-7.2.vmware.box'
        box.vm.box_download_checksum = 'f725042e3452963b9e17acb448140233b1227f13f42010433790528148497e70'
        box.vm.box_download_checksum_type = 'sha256'
        config.registration.username = ENV['RHN_USERNAME']
        config.registration.password = ENV['RHN_PASSWORD']
      end

      if options.has_key?(:network_node)
        box.vm.network :public_network, auto_config: false
      end

      # Virtualbox Provider
      box.vm.provider 'virtualbox' do |virtualbox, override|
        virtualbox.cpus   = options.has_key?(:cpus) ? options.cpus.to_i : 2
        virtualbox.memory = options.has_key?(:memory) ? options.memory.to_i : 1024
        virtualbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        virtualbox.linked_clone = true
      end

      # VMware Fusion Provider
      box.vm.provider 'vmware_fusion' do |vmware, override|
        # Enable nested virtualisation
        vmware.vmx["vhv.enable"] = "TRUE"
        vmware.vmx['numvcpus'] = options.has_key?(:cpus) ? options.cpus.to_i : 2
        vmware.vmx['memsize']  = options.has_key?(:memory) ? options.memory.to_i : 1024
        vmware.linked_clone = true
      end

      # Provision the box
      box.vm.provision 'shell', path: PROVISIONERS[PUPPET_VERSION]['client']
      box.vm.provision 'puppet' do |puppet|
        puppet.binary_path       = '/opt/puppetlabs/bin'
        puppet.environment       = 'vagrant'
        puppet.environment_path  = '..'
        puppet.hiera_config_path = 'vagrant/hiera.yaml'
        if options.has_key?(:facts)
          puppet.facter = config.user.facts.merge(options.facts)
        else
          puppet.facter = config.user.facts
        end
        puppet.options = [
          '--verbose',
          '--storeconfigs',
          '--storeconfigs_backend puppetdb',
        ]
      end
    end
  end
end
