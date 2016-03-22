#
class graphite_web::install {

  if $::graphite_web::manage_packages {
    create_resources('package', {
      'graphite-web' => {
        ensure => $graphite_web::gw_graphite_web_version,
        name   => $graphite_web::gw_graphite_web_pkg
      },
    })
  }
}
