# require lsb
class rng-tools (
  $active = true,
  $init_changes = false,
  $init_onlyif = ''
) {

  $pkg_name = $::operatingsystem ? {
    /(?i-mx:debian|ubuntu)/ => 'rng-tools',
    /(?i-mx:redhat|centos)/ => 'rng-utils',
  }

  package { "$pkg_name":
    require => Package['lsb'],
  }

  if $init_changes {
    sysvinit::init::config { "$pkg_name":
      changes => $init_changes,
      onlyif => $init_onlyif,
    }
  }

  case $::operatingsystem {
    /(?i-mx:redhat|centos)/: {
      file { '/etc/init.d/rng-tools':
        mode => 755, owner => root, group => 0,
        source => 'puppet:///modules/rng-tools/init',
        require => Package['rng-tools'],
        notify => Service['rng-tools'],
      }
    }
  }

  service { "$pkg_name":
    ensure => $active ? {
      true => true,
      default => false,
    },
    enable => $active,
    require => Package['rng-tools'],
  }
}
