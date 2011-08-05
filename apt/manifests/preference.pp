define apt::preference ( $pin, $priority = '1000', $order = '' ) {
  concat::fragment { "$name":
    target => '/etc/apt/preferences',
    content => "Package: $name
Pin: $pin
Pin-Priority: $priority

",
    order => $order,
  }
}
