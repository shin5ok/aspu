#!/usr/bin/env perl
use strict;
use warnings;

while (my $data = <STDIN>) {
  my ($path, $md5) = $data =~ /^(\S+)\s+(\S*)/;
  my $obj = Storage_Copy->new( $path, $md5 );
  $obj->copy;
}

package Storage_Copy 0.01;
use strict;
use warnings;
use Class::Accessor::Lite ( rw => [qw( path md5 )] );

our $command_format = qq{blobxfer %s %s %s --upload --saskey %s};

sub new {
  my ($class, $path, $md5) = @_;
  my $obj = bless {}, $class;
  $obj->path( $path );
  $obj->md5( $md5 );
  return $obj;
}

sub copy {
  my ($self) = @_;
  my $storage_obj = Storage_Select::get( $self->{path} ); 
  my $command = sprintf $command_format, 
                        $storage_obj->account,
                        $storage_obj->container,
                        $storage_obj->saskey;
  print $command, "\n";
}

sub _logging {

}

package Storage_Select 0.01;
use File::Basename;
use JSON;
use YAML;
# use Storage;

our $dispatch_yaml = qq{$ENV{HOME}/dispatch.yaml};
our $json_path = qq{$ENV{HOME}/define-storage.yaml};
my $dispatch_params //= YAML::LoadFile( $dispatch_yaml );
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
      $storage_name = $c->{name};
      last _DEFINE_CONFIG_;
    }
  }
  return Storage->new( $dispatch_params->{$storage_name} );
}

sub _get_config {
  return $define_storage if $define_storage;
  my $data = do {
    open my $fh, "<", $json_path;
    local $/;
    <$fh>;
  };
  $define_storage = decode_json( $data );
  return $define_storage;
}

package Storage;
use Class::Accessor::Lite ( rw => [qw( account container saskey )] );
use JSON;

sub new {
  my ($class, $params) = @_;
  bless $params, $class;
}

1;
