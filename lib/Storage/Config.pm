use strict;
use warnings;

package Storage::Config 0.01 {
  use YAML;

  my $config_path = exists $ENV{AZURE_STORAGE_SELECT_CONFIG_PATH}
                  ? $ENV{AZURE_STORAGE_SELECT_CONFIG_PATH}
                  : $ENV{HOME};

  our $config_yaml = qq{$config_path/config.yaml};

  my $dispatch_params //= YAML::LoadFile( $config_yaml );

  sub config {
    
  }

}

1;
