define network::interface (
  $ipv6         = false,
  $address      = 'dhcp',
  $netmask      = '255.255.255.0',
  $network      = false,
  $gateway      = false,
  $enable       = 'true',
  $bond_slaves  = false,
  $bond_mode    = 'active-backup',
  $bond_options = '    bond-miimon 100
    bond-downdelay 200
    bond-updelay 200'
  ) {

  case $::operatingsystem {
    /(?i-mx:debian|ubuntu)/: {
      concat::fragment { "network-interface-$device":
        target => '/etc/network/interfaces',
        content => template('network/debian/interface.erb'),
      }
    }
    /(?i-mx:redhat|centos)/: {
      if defined(File['/etc/sysconfig/network']) {}
      else {
        file { '/etc/sysconfig/network':
          mode => 600,
          content => template('network/redhat/network.erb'),
        }
      }
      file { "/etc/sysconfig/network-scripts/ifcfg-$device":
        mode => 600,
        content => template('network/redhat/ifcfg.erb'),
      }
      concat { "/etc/sysconfig/network-scripts/route-$device": }
    }
  }
}
