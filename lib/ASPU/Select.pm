use strict;
use warnings;
package ASPU::Select 0.01 {
  use Carp;
  require ASPU;

  sub new {
    my $obj = bless {}, shift;
    $obj->{config} = ASPU::Config->get;
    return $obj;
  }

  sub get {
    croak;
  }

}

1;
