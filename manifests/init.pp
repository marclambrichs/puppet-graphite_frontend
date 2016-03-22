# == Class: graphite_web
#
# Installs, configures and manages graphite-web service.
#
# === Parameters
#
# [*gw_graphite_web_pkg*]
#   Specifies the name of the graphite web package.
#   Default: 'graphite-web'
#
# [*gw_graphite_web_version*]
#   Specifies the version of the graphite web package.
#   Default: present
#
# [*manage_packages*]
#   Specifies if this module should or should not install packages.
#   Type: Boolean
#   Default: true
#
# === Examples
#
#  class { 'graphite_web': }
#
#
# === Authors
#
# Marc Lambrichs <marc.lambrichs@gmail.com>
#
# === Copyright
#
# Copyright 2016 Marc Lambrichs
#
class graphite_web (
  $manage_packages = $graphite_web::params::manage_packages,
  $gw_graphite_web_version = $graphite_web::params::gw_graphite_web_version,
  $gw_graphite_web_pkg     = $graphite_web::params::gw_graphite_web_pkg,
) inherits graphite_web::params {

  validate_bool( $manage_packages )

  validate_re( $gw_graphite_web_version, '^(present|\d+\.\d+\.\d+)$' )

  validate_string( $gw_graphite_web_pkg )

  anchor { 'graphite_web::begin': } ->
  class { 'graphite_web::install': } ->
  class { 'graphite_web::config': } ~>
  class { 'graphite_web::service': } ->
  anchor { 'graphite_wweb::end': }

}
