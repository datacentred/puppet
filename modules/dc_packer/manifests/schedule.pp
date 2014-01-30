# Class: dc_packer::schedule
#
# Takes care of setting up scheduling for the various Packer-related
# bits and pieces
#

class dc_packer::schedule {

  # Fetches the preseed template from Foreman
  cron { 'fetch_preseed':
    command => '/home/packer/bin/preseedme.rb',
    user    => 'packer',
    minute  => 0,
    hour    => 2,
  }
  
  # The actual Packer run itself
  cron { 'run_packer':
    command => 'cd /home/packer && bin/packer build -only=dcdevbox-vbox /home/packer/templates/dcdevboxbuild.json 2>&1 >> /home/packer/output/packerbuild.log',
    user    => 'packer',
    minute  => 0,
    hour    => 3,
  }
  
  # Make sure the latest-virtualbox symlink points to the most recent build
  cron { 'symlink_latest':
    command => "cd /home/packer/output && rm latest-virtualbox ; ln -s $(ls -lrt | awk '{ print $9 }' | grep vbox | tail -1) latest-virtualbox",
    user    => 'packer',
    minute  => 0,
    hour    => 5,
  }

}
