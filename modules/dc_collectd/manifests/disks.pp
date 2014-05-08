class dc_collectd::disks {

    # For disks we have 3 seperate facts which contain the devices
  # FIXME handle only having one entry in the string )
  # FIXME sort
  $mdarray = split($::software_raid, ',')
  $disksarray = split($::disks, ',')
  $partsarray = split($::partitions, ',')
  #$joinedarray = [ $mdarray, $disksarray, $partsarray ]
  $joinedarray = [ split($::mdarray, ','), split($::disksarray, ','), split($::partsarray, ',') ]
  $diskhashhost = suffix($joinedarray, "#${::hostname}")

  @@dc_gdash::diskperf { $diskhashhost: }

}

