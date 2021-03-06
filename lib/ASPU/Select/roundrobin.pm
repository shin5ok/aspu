use strict;
use warnings;
package ASPU::Select::roundrobin 0.01 {
  use Data::Dumper;
  use File::Basename;
  use ASPU::Select;
  use base qw(ASPU::Select);

  my $counter = sprintf "/var/tmp/.%s.count", basename __FILE__;
  my $storages_ref;

  sub get {
    my ($self, $name) = @_;
    my $config = $self->{config};

    $storages_ref //= [ sort keys %{$config->{storage}} ];

    my $index = _get_index( @$storages_ref + 0 );

    return ASPU->new( $config->{storage}->{$storages_ref->[$index]} );
  }

  sub _get_index {
    my $max = shift;
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
    if (++$data >= $max) {
      $data = 0;
    }
    print {$fh} $data;
    return $data;
  }

}

1;
