define sysvinit::init::config (
  $changes,
  $ensure = 'present',
  $onlyif = ''
) {

  augeas { "sysvinit-init-config-$name":
    context => "/files/etc/default/${name}",
    changes => $ensure ? {
      'absent' => "rm $name",
      default => $changes,
    },
    onlyif => $onlyif,
    require => Package["$name"],
    notify => Service["$name"],
  }
}
