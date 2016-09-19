package Storage::Copy 0.01;
use strict;
use warnings;
use Data::Dumper;
use Class::Accessor::Lite ( rw => [qw( path md5 )] );
use Storage::Select;
use My_Utils qw(logging);

our $command_format = qq{blobxfer %s %s %s --upload --computeblockmd5 --saskey '%s'};

sub new {
  my ($class, $path, $md5) = @_;
  my $obj = bless {}, $class;
  $obj->path( $path );
  $obj->md5( $md5 );
  return $obj;
}

sub copy {
  my ($self) = @_;
  my $storage_obj = Storage::Select::get( $self->{path} ); 
  my $command = sprintf $command_format, 
                        $storage_obj->account,
                        $storage_obj->container,
                        $self->{path},
                        $storage_obj->saskey;
  my $r = system $command . " > /dev/null";

  if ($r == 0) {
    _logging( "ok: $command" );
    return $storage_obj;
  } else {
    _logging( "NG: $command" );
    return undef;
  }
}

sub _logging {
  goto \&logging;
}

1;

