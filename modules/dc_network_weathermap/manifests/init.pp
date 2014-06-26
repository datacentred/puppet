class dc_network_weathermap {
  require network_weathermap

  file { '/var/www/network-weathermap/latest/lib/datasources/WeatherMapDataSource_graphite.php':
    source => 'puppet:///modules/dc_network_weathermap/WeatherMapDataSource_graphite.php',
  }

  file { '/var/www/network-weathermap/latest/images/DataCentred.png':
    source => 'puppet:///modules/dc_network_weathermap/DataCentred.png',
  }

  file { '/var/www/network-weathermap/latest/configs/DataCentred.conf':
    source => 'puppet:///modules/dc_network_weathermap/DataCentred.conf',
  }
}
