# == Class graphite_frontend::config
#
#
class graphite_frontend::config (
    $ls_carbonlink_hosts        = $graphite_frontend::ls_carbonlink_hosts,
    $ls_carbonlink_timeout      = $graphite_frontend::ls_carbonlink_timeout,
    $ls_conf_dir                = $graphite_frontend::ls_conf_dir,
    $ls_content_dir             = $graphite_frontend::ls_content_dir,
    $ls_dashboard_conf          = $graphite_frontend::ls_dashboard_conf,
    $ls_db_engine               = $graphite_frontend::ls_db_engine,
    $ls_db_name                 = $graphite_frontend::ls_db_name,
    $ls_default_cache_duration  = $graphite_frontend::ls_default_cache_duration,
    $ls_graphite_root           = $graphite_frontend::ls_graphite_root,
    $ls_graphtemplates_conf     = $graphite_frontend::ls_graphtemplates_conf,
    $ls_index_file              = $graphite_frontend::ls_index_file,
    $ls_log_dir                 = $graphite_frontend::ls_log_dir,
    $ls_memcached_hosts         = $graphite_frontend::ls_memcached_hosts,
    $ls_rrd_dir                 = $graphite_frontend::ls_rrd_dir,
    $ls_secret_key              = $graphite_frontend::ls_secret_key,
    $ls_storage_dir             = $graphite_frontend::ls_storage_dir,
    $ls_timezone                = $graphite_frontend::ls_timezone,
    $ls_whisper_dir             = $graphite_frontend::ls_whisper_dir,
    $memcached_enabled          = $graphite_frontend::memcached_enabled,
  ) {

  file { "${graphite_frontend::gw_webapp_dir}/local_settings.py":
    ensure  => file,
    content => template('graphite_frontend/etc/graphite-web/local_settings.py.erb'),
    group   => $graphite_frontend::gw_group,
    mode    => '0644',
    owner   => $graphite_frontend::gw_user,
    require => Package[$graphite_frontend::gw_graphite_web_pkg]
  }

  file { "${graphite_frontend::gw_webapp_dir}/graphite.wsgi":
    ensure  => file,
    content => template('graphite_frontend/etc/graphite-web/graphite.wsgi.erb'),
    group   => $graphite_frontend::gw_group,
    mode    => '0644',
    owner   => $graphite_frontend::gw_user,
    require => Package[$graphite_frontend::gw_graphite_web_pkg]
  }

  file { "${graphite_frontend::gw_webapp_dir}/dashboard.conf":
    ensure  => file,
    content => template('graphite_frontend/etc/graphite-web/dashboard.conf.erb'),
    group   => $graphite_frontend::gw_group,
    mode    => '0644',
    owner   => $graphite_frontend::gw_user,
    require => Package[$graphite_frontend::gw_graphite_web_pkg]
  }

  exec { 'init django db':
    command     => '/bin/python ./manage.py syncdb --noinput',
    cwd         => '/usr/lib/python2.7/site-packages/graphite',
    group       => $graphite_frontend::apache_group,
    refreshonly => true,
    require     => File["${graphite_frontend::gw_webapp_dir}/local_settings.py"],
    user        => $graphite_frontend::apache_user,
  }

  File["${graphite_frontend::gw_webapp_dir}/local_settings.py"] ~> Exec['init django db']

  selboolean {'httpd_can_network_connect':
    persistent => true,
    value      => on,
  }

  Selboolean['httpd_can_network_connect'] ~> Service[$graphite_frontend::apache_service_name]

  include apache

  $vhost_defaults = {
    vhost_name     => '*',
    port           => 80,
    error_log      => true,
    ssl            => false,
    ssl_protocol   => ['All', '-SSLv2', '-SSLv3'],
    ssl_cipher     => 'AES128+EECDH:AES128+EDH',
  }

  create_resources( 'apache::vhost', $graphite_frontend::vhosts, $vhost_defaults )

}
