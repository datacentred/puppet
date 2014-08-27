# Class: dc_role::osdata
#
# Core OpenStack MariaDB Galera Cluster
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::dcdbs {

  contain dc_profile::db::galera

}
