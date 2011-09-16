define apt::preference ( $package, $pin, $priority = '1000', $order = '' ) {
  file { "/etc/apt/preferences.d/${order}${name}.pref":
    content => "Package: $package
Pin: $pin
Pin-Priority: $priority

",
  }
}
