#!/usr/bin/env bash -eax
if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
	echo "Installing VMware Guest Additions"
	cd /tmp
	mkdir -p /mnt/cdrom
	mount -o loop /home/vagrant/linux.iso /mnt/cdrom
	tar zxvf /mnt/cdrom/VMwareTools-*.tar.gz -C /tmp/
	/tmp/vmware-tools-distrib/vmware-install.pl -d
	rm /home/vagrant/linux.iso
	umount /mnt/cdrom
fi

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
    echo "Installing VirtualBox Guest Additions"

	# Without libdbus virtualbox would not start automatically after compile
	apt-get -y install --no-install-recommends libdbus-1-3
	
	# Install the VirtualBox guest additions
	VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
	VBOX_ISO=VBoxGuestAdditions_$VBOX_VERSION.iso
	mount -o loop $VBOX_ISO /mnt
	yes|sh /mnt/VBoxLinuxAdditions.run
	umount /mnt
	
	#Cleanup VirtualBox
	rm $VBOX_ISO

	# Workaround for the guest additions being broken on 4.3.10
	# See https://www.virtualbox.org/ticket/12879
	ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
fi
