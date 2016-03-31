# == Class graphite_web::config
#
#
class graphite_web::config {

  file { "${graphite_web::gw_webapp_dir}/local_settings.py":
    ensure  => file,
    content => template('graphite_web/etc/graphite-web/local_settings.py.erb'),
    group   => $graphite_web::gw_group,
    mode    => '0644',
    owner   => $graphite_web::gw_user,
    require => Package[$graphite_web::gw_graphite_web_pkg]
  }

  file { "${graphite_web::gw_webapp_dir}/graphite.wsgi":
    ensure  => file,
    content => template('graphite_web/etc/graphite-web/graphite.wsgi.erb'),
    group   => $graphite_web::gw_group,
    mode    => '0644',
    owner   => $graphite_web::gw_user,
    require => Package[$graphite_web::gw_graphite_web_pkg]
  }

  file { "${graphite_web::gw_webapp_dir}/dashboard.conf":
    ensure  => file,
    content => template('graphite_web/etc/graphite-web/dashboard.conf.erb'),
    group   => $graphite_web::gw_group,
    mode    => '0644',
    owner   => $graphite_web::gw_user,
    require => Package[$graphite_web::gw_graphite_web_pkg]
  }

  exec { 'init django db':
    command     => '/bin/python ./manage.py syncdb --noinput',
    cwd         => '/usr/lib/python2.7/site-packages/graphite',
    refreshonly => true,
    require     => File["${graphite_web::gw_webapp_dir}/local_settings.py"]
  }

  include apache

  apache::vhost { $::hostname:
    vhost_name      => '*',
    port            => '80',
    serveraliases   => [ 'graphite2.arthurjames.vagrant' ],
    docroot         => '/usr/share/graphite/webapp',
    error_log       => true,
    error_log_file  => "${::hostname}.error.log",
    redirect_dest   => "https://${::fqdn}/",
    redirect_status => 'permanent',
    access_logs     => [ {
      file => "/var/log/httpd/${::hostname}.access.log",
    },],
    directories     => [ {
      provider   => 'location',
      path       => '/server-status',
      sethandler => 'server-status',
      require    => 'ip 127.0.0.1',
    },]
  }

  apache::vhost { "ssl.${::hostname}":
    vhost_name                  => '*',
    port                        => '443',
    serveraliases               => [ 'graphite2.arthurjames.vagrant' ],
    docroot                     => '/usr/share/graphite/webapp',
    error_log                   => true,
    error_log_file              => "${::hostname}.ssl_error.log",

    ssl                         => true,
    ssl_cert                    => "/etc/pki/tls/certs/${::fqdn}.cer",
    ssl_key                     => '/etc/pki/tls/private/private.key',
    ssl_protocol                => ['All', '-SSLv2', '-SSLv3'],
    ssl_cipher                  => 'AES128+EECDH:AES128+EDH',

    redirect_dest               => "https://${::fqdn}/",
    redirect_status             => 'permanent',

    wsgi_application_group      => '%{GLOBAL}',
    wsgi_daemon_process         => 'graphite',
    wsgi_daemon_process_options => {
      processes          => '8',
      threads            => '5',
      display-name       => '%{GROUP}',
      inactivity-timeout => '%{GLOBAL}'
    },
    wsgi_import_script          => '/usr/share/graphite/graphite-web.wsgi',
    wsgi_import_script_options  => {
      process-group     => 'graphite',
      application-group => '%{GLOBAL}',
    },
    wsgi_process_group          => 'graphite',
    wsgi_script_aliases         => {
      '/' => '/usr/share/graphite/graphite-web.wsgi'
    },
    access_logs                 => [ {
      file   => "/var/log/httpd/${::hostname}.ssl_access.log",
      format => 'combined_time',
    },],
    directories                 => [
      { provider            => 'directory',
        path                => '/usr/share/graphite',
        auth_type           => 'Basic',
        auth_name           => 'corporate key',
        auth_basic_provider => 'file ldap',
        auth_user_file      => '/etc/graphite-web/htaccess',
        sethandler          => 'None',
        custom_fragment     => '
    AuthLDAPURL "ldaps://graphite.arthurjames.vagrant/ou=People, o=ing"
    <LimitExcept OPTIONS>
      Require valid-user
    </LimitExcept>'
      },
      { provider   => 'location',
        path       => '/content/',
        sethandler => 'None',
      },
      { provider            => 'location',
        path                => '/media/',
        sethandler => 'None',
      },
      { provider   => 'location',
        path       => '/admin',
        require    => 'ip 127.0.0.1',
      },
    ],
    headers        => [
      'always set X-Content-Type-Options nosniff',
      'always set Access-Control-Allow-Origin %{AccessControlAllowOrigin}e env=AccessControlAllowOrigin',
      'always set Access-Control-Allow-Methods "DELETE, PUT, GET, POST, OPTIONS"',
      'always set Access-Control-Allow-Headers "origin, accept, X-Requested-With, Content-Type, authorization"',
      'always set Access-Control-Allow-Credentials true',
    ]
  }

}
