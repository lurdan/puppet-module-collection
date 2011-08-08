# Class: puppet::agent
#
class puppet::agent (
  $version = 'present',
  $active = true
  ) {

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

  if $puppet::agent_init_config {
    sysvinit::init::config { "$puppet_agent":
     changes => $puppet::agent_init_config,
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

