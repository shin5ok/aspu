use strict;
use warnings;

package ASU::Config 0.01 {
  use YAML;

  my $config_path = exists $ENV{AZURE_STORAGE_SELECT_CONFIG_PATH}
                  ? $ENV{AZURE_STORAGE_SELECT_CONFIG_PATH}
                  : $ENV{HOME};

  our $config_yaml = qq{$config_path/config.yaml};

  my $config_params //= YAML::LoadFile( $config_yaml );

  sub get {
    return $config_params;
  }

}

1;
