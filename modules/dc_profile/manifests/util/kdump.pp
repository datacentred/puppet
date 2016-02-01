#Class: dc_profile::util::kdump
#
# Enable linux-crashdump (k-dump) on a node.
# Ensure that there is enough RAM allocated to kdump as 128MB is not enough
#
# Parameters:
#
# Actions:
#
# Requires:
# Stdin
#
# Sample Usage:
#
class dc_profile::util::kdump {

  ensure_packages('linux-crashdump')

  file_line { 'kdump':
    path    => '/etc/default/kdump-tools',
    line    => 'USE_KDUMP=1',
    match   => 'USE_KDUMP=0',
    require => Package['linux-crashdump'],
  }

  file_line { 'grub.d update':
    path    => '/etc/default/grub.d/kexec-tools.cfg',
    line    => 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT crashkernel=384M-:256M"',
    match   => '^GRUB',
    require => Package['linux-crashdump'],
  }
}
