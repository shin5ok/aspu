use strict;
use warnings;
package ASU::Select 0.01 {
  use Carp;
  require ASU;

  sub new {
    my $obj = bless {}, shift;
    $obj->{config} = ASU::Config->get;
    return $obj;
  }

  sub get {
    croak;
  }

}

1;
