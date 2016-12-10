use strict;
use warnings;
package ASPU::Copy 0.01;
use Data::Dumper;
use File::Basename;
use Class::Accessor::Lite ( rw => [qw( path md5 config db )] );
use My_Utils qw(logging);
use utf8;
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
    open SAVEERR, ">&", STDERR;
    open SAVEOUT, ">&", STDOUT;
    open STDERR, ">", "/dev/null";
    open STDOUT, ">", "/dev/null";
    $r = system @commands;
    open STDERR, ">&", SAVEERR;
    open STDOUT, ">&", SAVEOUT;
  }
  print "ok ($$)\n";

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
  my $storage_obj = $self->operate("--upload");
  $self->db->upsert(
    "path",
    +{
      path      => $self->{path},
      storage   => $storage_obj->account,
      container => $storage_obj->container,
      filename  => basename $self->{path},
    },
  );
}

sub delete {
  my ($self) = @_;
  $self->operate("--delete");
  $self->db->delete_many( +{ path => $self->{path} });
}

sub _logging {
  goto \&logging;
}

1;

