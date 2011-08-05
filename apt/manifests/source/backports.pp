# = Class: apt::source::backports
#
# If you want to use backports, please include this.
# It choose distribution based on lsb parameter.
#
# Requires:
#   lsb
#
# Sample Usage:
#   include apt::source::backports
class apt::source::backports {
  apt::source { 'backports':
    url => 'http://backports.debian.org/debian-backports',
    dist => "${lsbdistcodename}-backports",
  }
}
