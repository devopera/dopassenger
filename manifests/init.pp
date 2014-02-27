class dopassenger (

  # class arguments
  # ---------------
  # setup defaults

  $passenger_gems_path = $dopassenger::params::passenger_gems_path,

  # end of class arguments
  # ----------------------
  # begin class

) inherits dopassenger::params {

  # install passenger deps
  case $operatingsystem {
    centos, redhat: {
      if ! defined(Package['gcc-c++']) {
        package { 'gcc-c++' : 
          ensure => 'installed',
          before => [Package['passenger']],
        }
      }
      if ! defined(Package['ruby-devel']) {
        package { 'ruby-devel' :
          ensure => 'installed',
          before => [Package['passenger']],
        }
      }
      if ! defined(Package['libcurl-devel']) {
        package { 'libcurl-devel' :
          ensure => 'installed',
          before => [Package['passenger']],
        }
      }
      if ! defined(Package['httpd-devel']) {
        package { 'httpd-devel' :
          ensure => 'installed',
          before => [Package['passenger']],
        }
      }
      if ! defined(Package['apr-devel']) {
        package { 'apr-devel' :
          ensure => 'installed',
          before => [Package['passenger']],
        }
      }
      if ! defined(Package['apr-util-devel']) {
        package { 'apr-util-devel' :
          ensure => 'installed',
          before => [Package['passenger']],
        }
      }
      if ! defined(Package['openssl-devel']) {
        package { 'openssl-devel' :
          ensure => 'installed',
          before => [Package['passenger']],
        }
      }
      if ! defined(Package['zlib-devel']) {
        package { 'zlib-devel' :
          ensure => 'installed',
          before => [Package['passenger']],
        }
      }
    }
    ubuntu, debian: {
      if ! defined(Package['libcurl4-openssl-dev']) {
        package { 'libcurl4-openssl-dev' :
          ensure => 'installed',
          before => [Package['passenger']],
        }
      }
      if ! defined(Package['apache2-threaded-dev']) {
        package { 'apache2-threaded-dev' :
          ensure => 'installed',
          before => [Package['passenger']],
        }
      }
      if ! defined(Package['libapr1-dev']) {
        package { 'libapr1-dev' :
          ensure => 'installed',
          before => [Package['passenger']],
        }
      }
      if ! defined(Package['libaprutil1-dev']) {
        package { 'libaprutil1-dev' :
          ensure => 'installed',
          before => [Package['passenger']],
        }
      }
    }
  }
  # install passenger gem
  if ! defined(Package['passenger']) {
    package { 'passenger' :
      ensure => 'installed',
      provider => 'gem',
    }
  }

  # install apache2 module
  exec { 'dopassenger-apache2-install-module' :
    path => '/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin',
    command => 'passenger-install-apache2-module --auto',
    require => [Package['passenger']],
  }->

  # create symlink 'latest-passenger' for vhost configs
  exec { 'dopassenger-apache2-symlink-latest' :
    path => '/bin:/usr/bin:/sbin:/usr/sbin',
    command => "find ${passenger_gems_path}/ -name 'passenger-*' -exec ln -s {} ${passenger_gems_path}/latest-passenger \;",
  }

}
