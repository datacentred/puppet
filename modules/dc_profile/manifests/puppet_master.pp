class dc_profile::puppet_master {

       class { '::puppet':
               server => true,
       }

}

