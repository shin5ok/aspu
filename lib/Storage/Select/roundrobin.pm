use strict;
use warnings;
package Storage::Select::roundrobin 0.01 {
  use Data::Dumper;
  use File::Basename;
  use Storage::Select;
  use base qw(Storage::Select);

  my $counter = sprintf "/var/tmp/%s.count", basename __FILE__;
  my $storages_ref;

  sub get {
    my ($self, $name) = @_;
    my $config = $self->{config};

    $storages_ref //= [ keys %{$config->{storage}} ];

    my $index = _get_index();

    return Storage->new( $config->{storage}->{$storages_ref->[$index]} );
  }

  sub _get_index {
    do {
      open my $fh, ">", $counter if ! -f $counter;
    };
    open my $fh, "+<", $counter;
    flock $fh, 2;
    seek $fh, 0, 0;
    my $data = <$fh>;
    $data //= 0;
    chomp $data;
    seek $fh, 0, 0;
    truncate $fh, 0;
    print {$fh} $data++;
    return $data;
  }

}

1;
