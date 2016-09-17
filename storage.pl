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

package Storage_Select 0.01;
use File::Basename;

sub get {
  my ($name) = @_;
  my $basename = basename $name;
  if ($basename =~ /^(a-z0-9)/i) {
  }
}

package Storage;
use Class::Accessor::Lite ( rw => [qw( account container saskey )] );

sub new {
  my ($class, %params) = @_;
}

1;
