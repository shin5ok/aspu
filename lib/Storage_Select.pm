package Storage_Select 0.01;
use File::Basename;
use JSON;
use YAML;
use Data::Dumper;
require Storage;
# use Storage;

# my $dispatch_yaml = qq{$ENV{HOME}/dispatch.json};
# my $json_path = qq{$ENV{HOME}/define-storage.yaml};
# my $dispatch_params //= YAML::LoadFile( $dispatch_yaml );
# my $define_storage;
# my $dispatch;
my $dispatch_json = qq{$ENV{HOME}/dispatch.json};
my $define_yaml = qq{$ENV{HOME}/define-storage.yaml};
my $dispatch_params //= YAML::LoadFile( $define_yaml );
my $define_storage;
my $dispatch;

sub get {
  my ($name) = @_;
  my $basename = basename $name;
  my $define_config = _get_config();
  my $storage_name;
  _DEFINE_CONFIG_:
  for my $c ( @$define_config ) {
    if ($basename =~ /^$c->{pattern}/i) {
      $storage_name = $c->{storage};
      last _DEFINE_CONFIG_;
    }
  }
  $storage_name //= $define_config->[0]->{storage};
  return Storage->new( $dispatch_params->{$storage_name} );
}

sub _get_config {
  return $define_storage if $define_storage;
  my $data = do {
    open my $fh, "<", $dispatch_json;
    local $/;
    <$fh>;
  };
  $define_storage = decode_json( $data );
  return $define_storage;
}

1;
