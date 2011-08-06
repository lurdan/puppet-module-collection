# Usage:
# network::resolver { "$::fqdn":
#   options => '',
#   domain => '',
#   search => '',
#   nameserver => [ 'xxx.xxx.xxx.xxx', 'xxx.xxx.xxx.xxx', ... ],
# }
define network::resolver (
  $nameserver,
  $options = '',
  $domain = '',
  $search= ''
  ) {
  file { "/etc/resolv.conf":
    content => template("network/resolv.conf.erb"),
  }
}
