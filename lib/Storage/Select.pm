use strict;
use warnings;
package Storage::Select 0.01 {
  use Carp;
  require Storage;
  require Storage::Config;

  sub new {
    my $obj = bless {}, shift;
    $obj->{config} = Storage::Config->get;
    return $obj;
  }

  sub get {
    croak;
  }

}

1;
