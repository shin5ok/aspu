package Storage::Select 0.01;
use File::Basename;
use JSON;
use YAML;
use Data::Dumper;
require Storage;

my $config_path = exists $ENV{AZURE_STORAGE_SELECT_CONFIG_PATH}
                ? $ENV{AZURE_STORAGE_SELECT_CONFIG_PATH}
                : $ENV{HOME};
our $dispatch_json = qq{$config_path/dispatch.json};
our $define_yaml = qq{$config_path/define-storage.yaml};
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
