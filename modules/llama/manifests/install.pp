# == Class: llama::install
#
# Installs requisite packages
#
class llama::install {

  assert_private()

  ensure_packages('python-setuptools')

}
