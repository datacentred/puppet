#
class dc_java {

  # puppetdb requires java, but doesn't install it or impose constraints
  # probably so you can chose a proprietary version if you like.  We just
  # use OpenJDK for now
  Class['dc_java'] -> Class['puppetdb']

  package { 'default-jre':
    ensure => present,
  }

}
