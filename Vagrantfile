# -*- mode: ruby -*-
# vi: set ft=ruby :

# Ensure everyone is running a consistent vagrant version
Vagrant.require_version '~> 1.7.2'

Vagrant.configure('2') do |config|
  config.vm.box              = 'puppetlabs/ubuntu-14.04-64-puppet'
  config.vm.box_version      = '1.0.1'
  config.vm.box_check_update = true

  # Provision using the root account.  This allows us to modify
  # the uid/gid namespaces before provisioning with puppet
  config.ssh.username = 'root'
  config.ssh.password = 'puppet'

  # Use landrush for DNS resolution
  config.landrush.enabled = true

  # Recurse all DNS queries via ns0/ns1 for now
  config.landrush.upstream '10.10.192.250'
  config.landrush.upstream '10.10.192.251'

  # Give every guest private networking
  #config.vm.network :private_network, type: :dhcp

  # Setup a dedicated PuppetDB for storedconfigs
  config.vm.define 'puppet' do |box|
    box.vm.network :private_network, type: :dhcp
    box.vm.hostname = 'puppet.vagrant.dev'
    box.vm.synced_folder '.', '/vagrant', :disabled => true
    box.vm.provision 'shell', path: 'vagrant/bootstrap_puppet.sh'
  end

  # Environment specific boxes (defined in .vagrantuser)
  config.user.boxes.each do |name, options|
    config.vm.define name.to_s do |box|
      box.vm.hostname = "#{name.to_s}.vagrant.dev"

      # Copy the eyaml keys
      config.vm.provision 'file', source: config.user.eyaml.private_key, destination: 'private_key.pkcs7.pem'
      config.vm.provision 'file', source: config.user.eyaml.public_key,  destination: 'public_key.pkcs7.pem'

      # Allow DHCP IP to be manually overriden
      if options.has_key?(:ip)
        box.vm.network :private_network, ip: options.ip
      else
        box.vm.network :private_network, type: :dhcp
      end

      # Allow ports to be forwarded
      if options.has_key?(:forwarded_ports)
        options.forwarded_ports.each do |name, forwarded_port|
          config.vm.network 'forwarded_port', guest: forwarded_port[:guest],
                                              host: forwarded_port[:host],
                                              protocol: forwarded_port[:protocol]
        end
      end

      # Provision some flavour of RHEL instead of the default Ubuntu Trusty
      if options.has_key?(:rhel)
        box.vm.box = 'puppetlabs/centos-7.0-64-puppet'
        box.vm.box_version = '1.0.1'
      end

      # Virtualbox Provider
      box.vm.provider 'virtualbox' do |virtualbox, override|
        virtualbox.cpus   = options.has_key?(:cpus) ? options.cpus.to_i : 2
        virtualbox.memory = options.has_key?(:memory) ? options.memory.to_i : 1024
        virtualbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end

      # VMware Fusion Provider
      box.vm.provider 'vmware_fusion' do |vmware, override|
        # Enable nested virtualisation
        vmware.vmx["vhv.enable"] = "TRUE"
        vmware.vmx['numvcpus'] = options.has_key?(:cpus) ? options.cpus.to_i : 2
        vmware.vmx['memsize']  = options.has_key?(:memory) ? options.memory.to_i : 1024
      end

      # Provision the box
      box.vm.provision 'shell', path: 'vagrant/bootstrap_client.sh'
      box.vm.provision 'puppet' do |puppet|
        puppet.manifests_path    = 'vagrant'
        puppet.module_path       = 'modules'
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
          '--environment vagrant',
        ]
      end
    end
  end
end
