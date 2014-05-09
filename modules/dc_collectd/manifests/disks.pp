class dc_collectd::disks {

  # For disks we have 3 separate facts which may contain the devices
  
  if $::software_raid {
    $joined_array = join("$::disks,$::partitions,$::software_raid",',')
  } else {
    $joined_array = join("$::disks,$::partitions",',')
  }

  $diskhashhost = suffix($joined_array, "#${::hostname}")

  @@dc_gdash::diskperf { $diskhashhost: }

}

