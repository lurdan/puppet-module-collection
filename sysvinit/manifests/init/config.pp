# Usage:
#   sysvinit::init::config { 'puppet':
#     $params => { ''  => '', '' => '', },
#   }
define sysvinit::init::config (
  $changes,
  $onlyif = ''
  ) {

  augeas { "sysvinit-init-config-$name":
    context => $::operatingsystem ? {
      /(?i-mx:debian|ubuntu)/ => "/files/etc/default/${name}",
#      /(?i-mx:redhat|centos)/ => "/files/etc/sysconfig/${name}",
    },
    changes => $changes,
    onlyif => $onlyif,
    require => Package["$name"],
    notify => Service["$name"],
  }
}
