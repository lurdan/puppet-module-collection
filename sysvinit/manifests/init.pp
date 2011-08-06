class sysvinit {
  package { 'sysvinit':
    name => $::operatingsystem ? {
      /(?i-mx:debian|ubuntu)/ => 'sysvinit',
      /(?i-mx:redhat|centos)/ => 'SysVinit',
    },
  }
  Package['sysvinit'] -> Sysvinit::Init::Config <| |> -> Service <| |>

  case $::virtual {
    /(?i-mx:openvz|lxc)/: {
      sysvinit::inittab { ['1', '2', '3', '4', '5', '6' ]:
        ensure => 'absent',
      }
    }
  }

  file { '/etc/inittab':
    ensure => present,
    require => Package['sysvinit'],
  }

  exec { 'inittab_refreshed':
    command => '/sbin/telinit q',
    refreshonly => true,
  }
}
