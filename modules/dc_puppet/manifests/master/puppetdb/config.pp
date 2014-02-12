class dc_puppet::master::puppetdb::config {

  file { "${dir}/puppetdb.conf":
  }

  file { "${dir}/routes.yaml":
  }

}
