class dc_repos::repolist {

include dc_repos::virtual

  $mirrorserver         = hiera(mirror_server)
  $ubuntumirrorpath     = hiera(ubuntu_mirror_path)
  $ubuntusecmirrorpath  = hiera(ubuntu_security_mirror_path)
  $puppetmirrorpath     = hiera(puppet_mirror_path)
  $cephcmirrorpath      = hiera(ceph_c_mirror_path)
  $cephdmirrorpath      = hiera(ceph_d_mirror_path)
  $nullmailermirrorpath = hiera(nullmailer_mirror_path)
  $virtualboxmirrorpath = hiera(virtualbox_mirror_path)
  $hpsupportmirrorpath  = hiera(hpsupport_mirror_path)
  $foremanmirrorpath    = hiera(foreman_mirror_path)
  $datacentredpath      = hiera(datacentred_path)
  $rsyslogmirrorpath    = hiera(rsyslog_mirror_path)

  @dc_repos::virtual::repo { 'local_precise_mirror':
    location => "$mirrorserver/$ubuntumirrorpath",
    release  => 'precise',
    repos    => 'main restricted universe multiverse',
    tag      => baserepos
  }

  @dc_repos::virtual::repo { 'local_precise_updates_mirror':
    location => "$mirrorserver/$ubuntumirrorpath",
    release  => 'precise-updates',
    repos    => 'main restricted universe multiverse',
    tag      => baserepos
  }

  @dc_repos::virtual::repo { 'local_precise_security_mirror':
    location => "$mirrorserver/$ubuntusecmirrorpath",
    release  => 'precise-security',
    repos    => 'main restricted universe',
    tag      => baserepos
  }

  @dc_repos::virtual::repo { 'local_puppetlabs_mirror':
    location => "$mirrorserver/$puppetmirrorpath",
    release  => 'precise',
    repos    => 'main dependencies',
    tag      => baserepos
  }

  @dc_repos::virtual::repo { 'local_nullmailer_backports_mirror':
    location   => "$mirrorserver/$nullmailermirrorpath",
    release    => 'precise',
    repos      => 'main',
    key        => 'E8B30951',
    key_server => 'keyserver.ubuntu.com',
    tag        => baserepos
  }

  @dc_repos::virtual::repo { 'ceph_c_mirror':
    location   => "$mirrorserver/$cephcmirrorpath",
    release    => 'precise',
    repos      => 'main',
    key        => '17ED316D',
    key_server => 'keyserver.ubuntu.com',
  }

  @dc_repos::virtual::repo { 'ceph_d_mirror':
    location   => "$mirrorserver/$cephdmirrorpath",
    release    => 'precise',
    repos      => 'main',
    key        => '17ED316D',
    key_server => 'keyserver.ubuntu.com'
  }

  @dc_repos::virtual::repo { 'local_virtualbox_mirror':
    location   => "$mirrorserver/$virtualboxmirrorpath",
    release    => 'precise',
    repos      => 'contrib',
    key        => '98AB5139',
    key_source => 'http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc',
  }

  @dc_repos::virtual::repo { 'local_hpsupport_mirror':
    location   => "$mirrorserver/$hpsupportmirrorpath",
    release    => 'precise/current',
    repos      => 'non-free',
    key        => '2689B887',
    key_source => 'http://downloads.linux.hp.com/SDR/downloads/MCP/GPG-KEY-mcp',
  }

  @dc_repos::virtual::repo { 'local_foreman_mirror':
    location   => "$mirrorserver/$foremanmirrorpath",
    release    => 'precise',
    repos      => 'stable',
    key        => 'E775FF07',
    key_source => 'http://deb.theforeman.org/foreman.asc',
  }

  @dc_repos::virtual::repo { 'local_datacentred_backports':
    location   => "${mirrorserver}/${datacentredpath}",
    release    => 'precise',
    repos      => 'universe',
    key        => '7CCDE6B0',
    key_source => "${mirrorserver}/${datacentredpath}/repo.gpg.key",
  }

  @dc_repos::virtual::repo {'local_rsyslog_mirror':
    location   => "$mirrorserver/$rsyslogmirrorpath/v8-devel",
    release    => 'precise/',
    repos      => '',
    key        => 'AEF0CF8E',
    key_server => 'keyserver.ubuntu.com',
    tag        => baserepos
  }

}
