class dopassenger (

  # class arguments
  # ---------------
  # setup defaults

  $passenger_gems_path = '/usr/lib/ruby/gems/1.8/gems',

  # end of class arguments
  # ----------------------
  # begin class

) {

  # install passenger deps
  if ! defined(Package['gcc-c++']) {
    package { 'gcc-c++' : ensure => 'installed', }
  }
  if ! defined(Package['ruby-devel']) {
    package { 'ruby-devel' : ensure => 'installed', }
  }
  # package doesn't seem to exist
  if ! defined(Package['libcurl-devel']) {
    package { 'libcurl-devel' : ensure => 'installed', }
  }
  if ! defined(Package['httpd-devel']) {
    package { 'httpd-devel' : ensure => 'installed', }
  }
  if ! defined(Package['apr-devel']) {
    package { 'apr-devel' : ensure => 'installed', }
  }
  if ! defined(Package['apr-util-devel']) {
    package { 'apr-util-devel' : ensure => 'installed', }
  }

  # install passenger gem
  if ! defined(Package['passenger']) {
    package { 'passenger' :
      ensure => 'installed',
      provider => 'gem',
      require => [Package['gcc-c++'], Package['ruby-devel'], Package['libcurl-devel'], Package['httpd-devel'], Package['apr-devel'], Package['apr-util-devel ']],
    }
  }
  
  # install apache2 module
  exec { 'dopassenger-apache2-install-module' :
    path => '/bin:/usr/bin:/sbin:/usr/sbin',
    command => 'passenger-install-apache2-module --auto',
    require => [Package['passenger']],
  }->

  # create symlink 'latest-passenger' for vhost configs
  exec { 'dopassenger-apache2-symlink-latest' :
    path => '/bin:/usr/bin:/sbin:/usr/sbin',
    command => "find ${passenger_gems_path}/ -name 'passenger-*' -exec ln -s {} ${passenger_gems_path}/latest-passenger \;",
    require => [Package['passenger']],
  }

}
