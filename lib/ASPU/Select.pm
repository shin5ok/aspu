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
    my ($self, $storage_name) = @_;
    ASPU->new(
      $self->{config}->{storage}->{$storage_name}
    );
  }

}

1;
