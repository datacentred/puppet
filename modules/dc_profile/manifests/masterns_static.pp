class { "network::interfaces":
  interfaces    => {
    "bond0"     => {
      "method"  => 'static',
      "address" => '10.10.192.250',
      "netmask" => '255.255.255.0',
      "gateway" => '10.10.192.1',
    }
  },
  auto => ["bond0"],
}
