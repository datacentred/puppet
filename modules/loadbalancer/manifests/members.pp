# == Class: loadbalancer::members
#
class loadbalancer::members (
  $member_hash,
) {

  create_resources('loadbalancer::member', $member_hash)

}
