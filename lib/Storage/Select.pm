use strict;
use warnings;
package Storage::Select 0.01;
use File::Basename;
use JSON;
use Data::Dumper;
require Storage;
require Storage::Config;

my $config = Storage::Config->get;
my $dispatch;

sub get {
  my ($name) = @_;
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
  return Storage->new( $config->{storage}->{$storage_name} );
}


1;
