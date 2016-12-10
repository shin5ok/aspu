use strict;
use warnings;
package ASPU::Copy 0.01;
use Data::Dumper;
use Class::Accessor::Lite ( rw => [qw( path md5 config db )] );
use My_Utils qw(logging);
require ASPU::Config;
require ASPU::DB;

our $command_format = qq{blobxfer %s %s %s --upload --saskey '%s' --strip-components=0};

sub new {
  my ($class, $path, $md5) = @_;
  my $obj = bless {}, $class;
  $obj->path( $path );
  $obj->md5( $md5 );
  $obj->config( ASPU::Config->get );
  $obj->db( ASPU::DB->new );
  return $obj;
}

sub operate {
  my ($self, $mode_string) = @_;
  my $storage_module = qq{ASPU::Select::} . $self->config->{copy_module};
  eval qq{use $storage_module};
  my $storage_obj = $storage_module->new->get( $self->{path} ); 
  my @commands = (
                   "blobxfer",
                   $storage_obj->account,
                   $storage_obj->container,
                   $self->{path},
                   "--saskey",
                   $storage_obj->saskey,
                   "--strip-components=0",
                  );
  push @commands, $mode_string;

  my $r;
  {
    open STDERR, ">", "/dev/null";
    open STDOUT, ">", "/dev/null";
    $r = system @commands;
  }

  my $command = join " ", @commands;
  if ($r == 0) {
    _logging( "ok: $command" );
    return $storage_obj;
  } else {
    _logging( "NG: $command" );
    return undef;
  }
}

sub copy {
  my ($self) = @_;
  $self->operate("--upload");
}

sub delete {
  my ($self) = @_;
  $self->operate("--delete");
}

sub _logging {
  goto \&logging;
}

1;

