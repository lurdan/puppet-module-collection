include lsb

class { 'rng-tools':
  init_changes => 'set HRNGDEVICE /dev/urandom',
  init_onlyif => "match *[id='HRNGDEVICE'] size == 0";
}
