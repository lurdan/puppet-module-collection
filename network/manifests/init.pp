# Class: network
#
# This module manages netbase
#
# Parameters:
#
# Actions:
#
# Requires:
#   concat
#
# Sample Usage:
#
class network (
  $bonding = false,
  $vlan = false
  ) {
  case $::operatingsystem {
    /(?i-mx:debian|ubuntu)/: {
      class { 'network::package::debian':
        bonding => $bonding,
        vlan => $vlan,
      }
      class { 'network::config::debian': }
    }
    /(?i-mx:redhat|centos)/: {
      class { 'network::package::redhat': }
      class { 'network::config::redhat': }
    }
    default: {
      err ("network module undefined.")
    }
  }

  service { 'networking': }
}

