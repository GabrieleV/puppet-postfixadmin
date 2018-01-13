#
# internal class that installs an apache vhost
# Parameters are inherited from postfixadmin::vhost
# 
class postfixadmin::vhost::apache (
  $servername      = $postfixadmin::vhost::servername,
  $serveraliases   = $postfixadmin::vhost::serveraliases,
  $docroot         = $postfixadmin::vhost::docroot,
  $apache_vhost    = {},
  $ssl             = $postfixadmin::vhost::ssl,
  $ssl_cert        = $postfixadmin::vhost::ssl_cert,
  $ssl_key         = $postfixadmin::vhost::ssl_key,
  $ssl_chain       = $postfixadmin::vhost::ssl_chain,
  $redirect_to_ssl = $postfixadmin::vhost::redirect_to_ssl,
) inherits postfixadmin::vhost {

  include ::apache
  include ::apache::mod::php

  $vhost = {
    $servername => {
      'serveraliases' => $serveraliases,
      'docroot'       => $docroot,
      'ssl'           => $ssl,
      'ssl_cert'      => $ssl_cert,
      'ssl_key'       => $ssl_key,
      'ssl_chain'     => $ssl_chain,
      'port'          => '443',
    },
  }

  create_resources('apache::vhost', $vhost, $apache_vhost)

  if $ssl and $redirect_to_ssl {
    $redir_vhost = {
      "${servername}_nossl" => {
        'servername'      => $servername,
        'serveraliases'   => $serveraliases,
        'docroot'         => $docroot,
        'port'            => 80,
        'redirect_status' => 'permanent',
        'redirect_dest'   => "https://${servername}/",
      },
    }

    create_resources('apache::vhost', $redir_vhost)
  }
}