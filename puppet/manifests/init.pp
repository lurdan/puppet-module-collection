# Class: puppet
#

class puppet (
  $version = 'present',
  $agent = 'active',
  $agent_init_changes = false,
  $agent_init_onlyif = '',
  $master = false,
  $master_init_changes = false,
  $master_init_onlyif = ''
)
{

  anchor { 'puppet::begin': }
  anchor { 'puppet::end': }


  if $agent {
    class { 'puppet::agent':
      version => $version,
      active => $agent ? {
        'active' => true,
        default => false,
      },
      init_changes => $agent_init_changes,
      init_onlyif => $agent_init_onlyif,
    }
  }
  if $master {
    class { 'puppet::master':
      version => $version,
      active => $master ? {
        'active' => true,
        default => false,
      },
      init_changes => $master_init_changes,
      init_onlyif => $master_init_onlyif,
    }
  }
}

define puppet::config ( $content ) {
  file { "$name":
    mode => 644, owner => root, group => 0,
    content => $content,
  }
}
