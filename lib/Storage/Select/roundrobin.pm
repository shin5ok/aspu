use strict;
use warnings;
package Storage::Select::roundrobin 0.01 {
  use Data::Dumper;
  use Storage::Select;
  use base qw(Storage::Select);

  sub get {
    my ($self, $name) = @_;
    my $config = $self->{config};
    return Storage->new( $config->{storage}->{$storage_name} );
  }

}

1;
