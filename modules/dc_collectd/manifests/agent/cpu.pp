class dc_collectd::agent::cpu {

  $cpu_array = prefix((split($::cpunumbers,',')),'cpu-')

  $cpuhashhost = suffix($cpu_array, "#${::hostname}")

  @@dc_gdash::cpu { $cpuhashhost: }

}

