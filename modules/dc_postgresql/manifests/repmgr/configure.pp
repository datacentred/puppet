# == Class: dc_postgresql::repmgr::configure
#
# Generic repmgr configuration
#
class dc_postgresql::repmgr::configure {

  $_conf = "${::dc_postgresql::repmgr::home}/repmgr.conf"
  $_cluster = $::dc_postgresql::repmgr::cluster_name
  $_cluster_master_node = $::dc_postgresql::repmgr::cluster_master_node
  $_node_id = $::dc_postgresql::repmgr::nodemap[$::fqdn]

  passwordless_ssh { 'postgres':
    ssh_private_key => $::dc_postgresql::repmgr::ssh_private_key,
    ssh_public_key  => $::dc_postgresql::repmgr::ssh_public_key,
    home            => $::dc_postgresql::repmgr::home,
    # TODO: Temporary hack while I think about ssh architecture
    options         => {
      "Host ${_cluster_master_node}" => {
        'StrictHostKeyChecking' => 'no',
        'UserKnownHostsFile'    => '/dev/null',
      },
    },
  }

  file { $_conf:
    ensure  => file,
    content => template('dc_postgresql/repmgr.conf.erb'),
  }

}
