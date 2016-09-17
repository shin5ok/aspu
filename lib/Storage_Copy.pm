package Storage_Copy 0.01;
use strict;
use warnings;
use Data::Dumper;
use Class::Accessor::Lite ( rw => [qw( path md5 )] );
use Storage_Select;

our $command_format = qq{blobxfer %s %s %s --upload --saskey '%s'};

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
                        $self->{path},
                        $storage_obj->saskey;
  print $command, "\n";
}

sub _logging {

}

1;

