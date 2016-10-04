use strict;
use warnings;
package ASU::Copy 0.01;
use Data::Dumper;
use Class::Accessor::Lite ( rw => [qw( path md5 config )] );
use My_Utils qw(logging);
require ASU::Config;

our $command_format = qq{blobxfer %s %s %s --upload --computeblockmd5 --saskey '%s'};

sub new {
  my ($class, $path, $md5) = @_;
  my $obj = bless {}, $class;
  $obj->path( $path );
  $obj->md5( $md5 );
  $obj->config( ASU::Config->get );
  return $obj;
}

sub copy {
  my ($self) = @_;
  my $storage_module = qq{ASU::Select::} . $self->config->{copy_module};
  eval qq{use $storage_module};
  my $storage_obj = $storage_module->new->get( $self->{path} ); 
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
