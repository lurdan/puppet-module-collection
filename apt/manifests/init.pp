# = Class: apt
#
#
# Parameters:
#
# Defines:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class apt ( $util = false ) {
  package {
    'debian-archive-keyring':
      ensure => latest;
  }

  if $util {
    package { 'apt-utils': ensure => installed, }
    Package['apt-utils'] -> Apt::Ftparchive::Root <| |>
  }

  exec {
    'apt-updated': command => '/usr/bin/apt-get update';
## uncomment after puppet issues #6748, #7422, #8050 solved
#    'apt-preseed-cleanup':
#      command => '/usr/bin/rm -f /var/cache/debconf/*.preseed',
#      refreshonly => true;
  }

  concat {'/etc/apt/preferences' :
    warn => false,
    before => Exec['apt-updated'];
  }

  Apt::Key <| |> -> Apt::Conf <| |> -> Exec['apt-updated']
  Apt::Source <| |> -> Exec['apt-updated']
  Apt::Preference <| |> -> Exec['apt-updated']
  Exec['apt-updated'] -> Package <| |> #-> Exec['apt-preseed-cleanup']
}
