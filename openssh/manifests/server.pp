class openssh::server (
  $version = 'present',
  $active = true,
  $server_config = false,
  $init_changes = false,
  $init_onlyif = ''
) {

  package { 'openssh-server':
    ensure => $version,
  }

  if $init_changes {
    case $::operatingsystem {
      /(?i-mx:debian|ubuntu)/: {
        sysvinit::init::config { 'ssh':
          changes => $init_changes,
          onlyif => $init_onlyif,
        }
      }
    }
  }

  service { 'openssh-server':
    name => $::operatingsystem ? {
      /(?i-mx:debian|ubuntu)/ => 'ssh',
      /(?i-mx:redhat|centos)/ => 'sshd',
    },
    ensure => $active ? {
      true => running,
      default => stopped,
    },
    enable => $active,
    hasrestart => true,
    require => Package['openssh-server'],
  }

  if $server_config {
    file { "/etc/ssh/sshd_config":
      mode => 400,
      content => $server_config,
      require => Package['openssh-server'],
      notify => Service['openssh-server'],
    }
  }
}
