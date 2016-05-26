# == Class: dc_icinga2::ark_hosts
#
# Static hosts in Ark (e.g. PDUs)
#
class dc_icinga2::ark_hosts {

  dc_icinga2::virtual_host { 'ark-pdu-a1-a.sal01.datacentred.co.uk':
    address    => '10.10.129.39',
    vars       => {
      'role'                     => 'apc-pdu',
      'environmental_monitoring' => true,
    },
    icon_image => 'http://incubator.storage.datacentred.io/apc-logo-16x16.png',
  }

  dc_icinga2::virtual_host { 'ark-pdu-a1-b.sal01.datacentred.co.uk':
    address    => '10.10.129.24',
    vars       => {
      'role' => 'apc-pdu',
    },
    icon_image => 'http://incubator.storage.datacentred.io/apc-logo-16x16.png',
  }

  dc_icinga2::virtual_host { 'ark-pdu-a2-a.sal01.datacentred.co.uk':
    address    => '10.10.129.31',
    vars       => {
      'role'                     => 'apc-pdu',
      'environmental_monitoring' => true,
    },
    icon_image => 'http://incubator.storage.datacentred.io/apc-logo-16x16.png',
  }

  dc_icinga2::virtual_host { 'ark-pdu-a2-b.sal01.datacentred.co.uk':
    address    => '10.10.129.27',
    vars       => {
      'role' => 'apc-pdu',
    },
    icon_image => 'http://incubator.storage.datacentred.io/apc-logo-16x16.png',
  }

  dc_icinga2::virtual_host { 'ark-pdu-a3-a.sal01.datacentred.co.uk':
    address    => '10.10.129.38',
    vars       => {
      'role' => 'apc-pdu',
    },
    icon_image => 'http://incubator.storage.datacentred.io/apc-logo-16x16.png',
  }

  dc_icinga2::virtual_host { 'ark-pdu-a3-b.sal01.datacentred.co.uk':
    address    => '10.10.129.25',
    vars       => {
      'role' => 'apc-pdu',
    },
    icon_image => 'http://incubator.storage.datacentred.io/apc-logo-16x16.png',
  }

  dc_icinga2::virtual_host { 'ark-pdu-b1-a.sal01.datacentred.co.uk':
    address    => '10.10.129.37',
    vars       => {
      'role'                     => 'apc-pdu',
      'environmental_monitoring' => true,
    },
    icon_image => 'http://incubator.storage.datacentred.io/apc-logo-16x16.png',
  }

  dc_icinga2::virtual_host { 'ark-pdu-b1-b.sal01.datacentred.co.uk':
    address    => '10.10.129.35',
    vars       => {
      'role' => 'apc-pdu',
    },
    icon_image => 'http://incubator.storage.datacentred.io/apc-logo-16x16.png',
  }

  dc_icinga2::virtual_host { 'ark-pdu-b2-a.sal01.datacentred.co.uk':
    address    => '10.10.129.34',
    vars       => {
      'role'                     => 'apc-pdu',
      'environmental_monitoring' => true,
    },
    icon_image => 'http://incubator.storage.datacentred.io/apc-logo-16x16.png',
  }

  dc_icinga2::virtual_host { 'ark-pdu-b2-b.sal01.datacentred.co.uk':
    address    => '10.10.129.26',
    vars       => {
      'role' => 'apc-pdu',
    },
    icon_image => 'http://incubator.storage.datacentred.io/apc-logo-16x16.png',
  }

  dc_icinga2::virtual_host { 'ark-pdu-b3-a.sal01.datacentred.co.uk':
    address    => '10.10.129.33',
    vars       => {
      'role' => 'apc-pdu',
    },
    icon_image => 'http://incubator.storage.datacentred.io/apc-logo-16x16.png',
  }

  dc_icinga2::virtual_host { 'ark-pdu-b3-b.sal01.datacentred.co.uk':
    address    => '10.10.129.28',
    vars       => {
      'role' => 'apc-pdu',
    },
    icon_image => 'http://incubator.storage.datacentred.io/apc-logo-16x16.png',
  }

  dc_icinga2::virtual_host { 'ark-pdu-b5-a.sal01.datacentred.co.uk':
    address    => '10.10.129.43',
    vars       => {
      'role'                     => 'apc-pdu',
      'environmental_monitoring' => true,
    },
    icon_image => 'http://incubator.storage.datacentred.io/apc-logo-16x16.png',
  }

  dc_icinga2::virtual_host { 'ark-pdu-b5-b.sal01.datacentred.co.uk':
    address    => '10.10.129.45',
    vars       => {
      'role' => 'apc-pdu',
    },
    icon_image => 'http://incubator.storage.datacentred.io/apc-logo-16x16.png',
  }

  dc_icinga2::virtual_host { 'ark-pdu-b6-a.sal01.datacentred.co.uk':
    address    => '10.10.129.44',
    vars       => {
      'role'                     => 'apc-pdu',
      'environmental_monitoring' => true,
    },
    icon_image => 'http://incubator.storage.datacentred.io/apc-logo-16x16.png',
  }

  dc_icinga2::virtual_host { 'ark-pdu-b6-b.sal01.datacentred.co.uk':
    address    => '10.10.129.48',
    vars       => {
      'role' => 'apc-pdu',
    },
    icon_image => 'http://incubator.storage.datacentred.io/apc-logo-16x16.png',
  }

}
