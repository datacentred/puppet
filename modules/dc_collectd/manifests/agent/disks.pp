# == Class: dc_collectd::agent::disks
#
class dc_collectd::agent::disks {

  # For disks we have 3 separate facts which may contain the devices

  if $::software_raid {
    $joined_array = split("${::disks},${::partitionstr},${::software_raid}",',')
  } else {
    $joined_array = split("${::disks},${::partitionstr}",',')
  }

  $diskhashhost = suffix($joined_array, "#${::hostname}")

  @@dc_gdash::diskperf { $diskhashhost: }

}

