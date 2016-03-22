# == Class graphite_web::params
#
#
class graphite_web::params {

  $manage_packages         = true
  $gw_graphite_web_version = present
  $gw_graphite_web_pkg     = 'graphite_web'

}
