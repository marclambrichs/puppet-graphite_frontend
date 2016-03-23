# == Class graphite_web::service
#
#
class graphite_web::service {

  service { $::graphite_web::apache_service_name:
    ensure => running,
    enable => true,
  }
}
