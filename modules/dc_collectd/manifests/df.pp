class dc_collectd::df {

  $df_array = split($::mounts,',')

  $dfhashhost = suffix($df_array, "#${::hostname}")

  @@dc_gdash::df { $dfhashhost: }

}

