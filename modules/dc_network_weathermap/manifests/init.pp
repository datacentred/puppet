class dc_network_weathermap {
  require network_weathermap

  file { '/opt/network-weathermap/latest/lib/datasources/WeatherMapDataSource_graphite.php':
    source => 'puppet:///modules/dc_network_weathermap/WeatherMapDataSource_graphite.php',
  }

  file { '/opt/network-weathermap/latest/images/DataCentred.png':
    source => 'puppet:///modules/dc_network_weathermap/DataCentred.png',
  }

  file { '/opt/network-weathermap/latest/configs/DataCentred.conf':
    source => 'puppet:///modules/dc_network_weathermap/DataCentred.conf',
  }
}
