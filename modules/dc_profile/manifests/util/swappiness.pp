# Class: dc_profile::util::swappiness
#
# Ensures sysctls is loaded to set swappiness 
#
class dc_profile::util::swappiness {

  include ::sysctls

}
