class dc_collectd::cpu {

  $cpu_array = prefix((split($::cpunumbers,',')),'cpu-')

  $cpuhashhost = suffix($cpu_array, "#${::hostname}")

  @@dc_gdash::cpu { $cpuhashhost: }

}

