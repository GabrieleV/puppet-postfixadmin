# install packages
class postfixadmin::install (
  String $package_name   = $postfixadmin::params::package_name,
  Array  $packages       = [],
  String $package_ensure = 'installed',
) inherits postfixadmin::params {

  package{'postfix-admin':
    ensure => $package_ensure,
    name   => $package_name,
  }

  $package_default = {
    ensure => $package_ensure,
    tag    => 'postfixadmin-packages',
  }
  ensure_packages($packages, $package_default)

}
