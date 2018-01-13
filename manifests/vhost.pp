#
# This class chooses the type of vhost 
# to run webserver
#
# Parameters:
#
#  $type
#    type of vhost to run. currently only apache supported (default)
#  $servername
#    Servername (defaults to $::fqdn)
#  $serveraliases
#    Array of Serveraliasess to listen to (default [])
#  $docroot
#    Document root
#    defaults to $postfixadmin::params::docroot
#  $ssl
#    If true, use ssl (defaults to false)
#    If true, you also need to set cert, key and chain.
#  $ssl_cert
#    ssl cert to use 
#  $ssl_key
#    ssl key to use
#  $ssl_chain
#    ssl chain to use
#  $redirect_to_ssl
#    if true, redirects all non https requests to https
#    defaults to true.
#  $create_resources
#  $create_resources
#    a Hash of Hashes to create additional resources eg. to 
#    retrieve a certificate.
#    Defaults to {} (do not create any additional resources)
#    Example (hiera):
#
#    postfixadmin::vhost::create_resources:
#        sslcert::get_cert:
#            get_my_postfix_cert:
#              private_key_path: '/etc/postfixadmin/ssl/key.pem'
#              cert_path: '/etc/postfixadmin/ssl/cert.pem'
#
#    Will result in  executing:
#
#    sslcert::get_cert{'get_my_postfix_cert':
#      private_key_path => '/etc/postfixadmin/ssl/key.pem'
#      cert_path        => '/etc/postfixadmin/ssl/cert.pem'
#    }
#
class postfixadmin::vhost (
  $type             = 'apache',
  $servername       = $::fqdn,
  $serveraliases    = [],
  $docroot          = $postfixadmin::params::docroot,
  $ssl              = false,
  $ssl_cert         = unset,
  $ssl_key          = unset,
  $ssl_chain        = unset,
  $redirect_to_ssl  = true,
  $create_resources = {},
) inherits postfixadmin::params {

  case $type {
    'apache': { include ::postfixadmin::vhost::apache }
    default: { fail("Webserver '${type}' is not supported") }
  }

  $create_resources.each | $res, $vals | {
    create_resources($res, $vals )
  }
}