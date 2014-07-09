#!/usr/bin/env bash

# Script to update BIOS and IPMI / BMC firmware
# on SuperMicro X8DTT series machines.

# nick.jones@datacentred.co.uk

## Versions
IPMIFWVER="2.20"
BIOSFWVER="2.1b"

## Filesystem locations
FWHOME=/usr/local/lib/firmware
### IPMI Firmware
IPMIFW=$FWHOME/X8DTT220.ima
### BIOS Firmware.  Note that this should be a dump (via flashrom) from a configured
### machine, and should match the NVRAM dump taken below.
BIOSFW=$FWHOME/bios_21b.bin
### NVRAM settings.  See above.
NVRAM=$FWHOME/dcnvram_080714.bin

## Tools
YAFUHOME=/usr/local/bin
YAFU_LIBRARY_PATH=/usr/local/lib/ipmi
IPMITOOL=$(which ipmitool)
FLASHROM=$(which flashrom)
NVRAMTOOL=$(which nvramtool)

## Services
TIMESERVER=ntp0

function check_hardware {
	# Check if we're a Supermicro machine and exit if we're not
        if ! dmidecode | grep -m 1 Supermicro >/dev/null; then
        	echo "Not Supermicro platform - exiting"
                exit
        fi
}

function check_ipmi_ver {
	# Checks whether the current IPMI firmware revision matches what's defined in $IPMIFWVER
	if [ $($IPMITOOL mc info | grep 'Firmware Revision' | awk '{ print $4 }') != $IPMIFWVER ]; then
		return 1
	fi
}

function set_usb {
	# For the IPMI firmware update to work locally, the BMC has to be in 'attach' mode
	echo "Setting BMC USB interface to 'attach' mode... "
	$IPMITOOL raw 0x30 0x70 0x0b 0x0
	echo "... done!"
}

function update_ipmi {
	# Updates IPMI firmware to version passed as $1
	echo "Beginning IPMI firmware update process, hit Ctrl-C to cancel... "
	sleep 5
	LD_LIBRARY_PATH=$YAFU_LIBRARY_PATH:$LD_LIBRARY_PATH $YAFUHOME/Yafuflash -cd -full $1
	echo "... done!"
}

function set_ipmi_dedicated {
	# By default, IPMI will attempt to 'share' the primary NIC instead of using the dedicated LAN
	# interface.  This sets it to the latter.
	echo "Setting IPMI network interface to 'dedicated'... "
	$IPMITOOL raw 0x30 0x70 0xc 1 1 0
	echo "... done! "
}

function update_bios {
	# Updates motherboard BIOS to version passed as $1
	echo "Beginning BIOS update process, hit Ctrl-C to cancel... "
	sleep 5
	$FLASHROM -w $1 -p internal
	echo "... done!"
}

function verify_bios {
	# Function to verify current BIOS
	# Returns 0 if successful
	echo "Verifying BIOS against $1 ..."
	$FLASHROM -v $1 -p internal
}

function check_bios_version {
	BIOSVER=`dmidecode | grep -A 2 "BIOS Information" | grep Version | cut -d ":" -f 2 | sed -e 's/^[ \t]*//' | sed 's/[ \t]*$//'`
	echo "Installed BIOS is $BIOSVER"
	echo "Newest BIOS is $BIOSFWVER"
	if [ $BIOSVER != $BIOSFWVER ]; then
		echo "BIOS levels do not match"
		export UPDATE=1
	else
		echo "BIOS levels match"
	fi
}

function copy_bios_settings {
	# Copies BIOS settings, requires 'nvram' LKM to loaded and /dev/nvram present
	# We don't check for this as it's part of our base image.
	# Also needs 'nvramtool' to work properly.
	echo "Copying BIOS settings... "
	$NVRAMTOOL -B $NVRAM
	echo "... done!"
}

function set_hw_clock {
    # Updates the time from a time server and sets the hw clock
    echo "Updating system clock from time server .."
    if ntpdate $TIMESERVER; then
        echo "Setting hardware clock"
        if hwclock --systohc --utc --noadjfile; then
            echo "Hardware clock set correctly"
        else
            echo "Could not set hardware clock"
        fi
    else
        echo "Could not update from time server"
    fi
}

case $1 in
	check_ipmi)
		check_hardware
		check_ipmi_ver
		;;
	verify_bios)
		check_hardware
		verify_bios $BIOSFW
		;;
	check_bios_version)
		check_hardware
		check_bios_version
		;;
	update_ipmi)
		check_hardware
		set_usb
		update_ipmi $IPMIFW
		set_ipmi_dedicated
		;;
	update_bios)
		check_hardware
		update_bios $BIOSFW
		copy_bios_settings
		;;
    set_hw_clock)
        set_hw_clock
        ;;
	full)
		# Full check / update where necessary process for BIOS and IPMI firmware
		check_hardware
		# Check IPMI version, if it's not what we expect then we upgrade
		if ! check_ipmi_ver; then
			echo "IPMI firmware version mismatch, upgrading to $IPMIFWVER"
		 	set_usb
		 	update_ipmi $IPMIFW
		 	set_ipmi_dedicated
		fi
		# Same for BIOS version, check against known good file and if there's any mismatch we upgrade
		check_bios_version
		if [ $UPDATE ] ; then
		 	update_bios $BIOSFW
		 	copy_bios_settings
		fi
        set_hw_clock
		;;
	*)
		echo "Usage: $0 {check_ipmi|verify_bios|check_bios_version|update_ipmi|update_bios|set_hw_clock|full}"
		;;
esac
