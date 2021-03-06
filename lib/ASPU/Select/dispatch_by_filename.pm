use strict;
use warnings;
package ASPU::Select::dispatch_by_filename 0.01 {
  use File::Basename;
  use JSON;
  use Data::Dumper;
  use ASPU::Select;
  use base qw(ASPU::Select);

  sub get {
    my ($self, $name) = @_;
    my $config = $self->{config};
    my $basename = basename $name;
    my $dispatch_config = $config->{copy_module_params}->{dispatch_by_filename};
    my $storage_name;
    _DISPATCH_CONFIG_:
    for my $c ( @$dispatch_config ) {
      if ($basename =~ /^$c->{pattern}/i) {
        $storage_name = $c->{storage};
        last _DISPATCH_CONFIG_;
      }
    }
    $storage_name //= $dispatch_config->[0]->{storage};
    return ASPU->new( $config->{storage}->{$storage_name} );
  }

}

1;
