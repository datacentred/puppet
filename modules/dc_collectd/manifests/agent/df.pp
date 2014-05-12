class dc_collectd::agent::df {

  $df_array = split($::mounts,',')

  $dfhashhost = suffix($df_array, "#${::hostname}")

  @@dc_gdash::df { $dfhashhost: }

}

