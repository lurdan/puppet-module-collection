# Class: puppet::agent
#
class puppet::agent (
  $version = 'present',
  $active = true,
  $daemon_opts = ''
)
{
  # workaround for facter dependency to ensure pciutils
  package {
    'facter': before => Package['puppet-agent'];
    'pciutils': before => Package['facter'];
  }
  # workaround for old debian package (< 2.7)
  if $::puppetversion =~ /^2.6/ {
    include augeas
    Package['ruby-augeas'] -> Package['puppet-agent']
  }

  anchor { 'puppet::agent::begin': }
  anchor { 'puppet::agent::end': }

  $puppet_agent = $::operatingsystem ? {
    default => 'puppet',
  }
  package {
    'puppet-agent':
      name => $puppet_agent,
      ensure => $version,
      require => [ Anchor['puppet::agent::begin'], Package['lsb'] ];
  }

  if $init_changes {
    sysvinit::init::config { "$puppet_agent":
      changes => $init_changes,
      onlyif => $init_onlyif,
    }
  }

  service { 'puppet-agent':
    name => $puppet_agent,
    ensure => $active ? {
      true => running,
      default => stopped,
    },
    enable => $active,
    subscribe => Package['puppet-agent'],
    before => Anchor['puppet::agent::end'],
  }
}
