# == class graphite_frontend::auth
#
#
class graphite_frontend::service::auth {
  exec { 'htpasswd':
    command => 'htpasswd -bc /etc/httpd/conf/htpasswd graphite graphite',
    creates => '/etc/httpd/conf/htpasswd',
    group   => 'root',
    user    => 'root',
  }
}
