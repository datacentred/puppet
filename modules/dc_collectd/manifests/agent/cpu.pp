# == Class: dc_collectd::agent::cpu
#
class dc_collectd::agent::cpu {

  $cpu_array = split($::cpunumbers,',')

  $cpuhashhost = suffix($cpu_array, "#${::hostname}")

  @@dc_gdash::cpu { $cpuhashhost: }

}

