package Storage::Copy 0.01;
use strict;
use warnings;
use Data::Dumper;
use Class::Accessor::Lite ( rw => [qw( path md5 )] );
use Sys::Syslog qw(:DEFAULT setlogsock);
use Storage::Select;
use Storage::DB;

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
  my $storage_obj = Storage::Select::get( $self->{path} ); 
  my $command = sprintf $command_format, 
                        $storage_obj->account,
                        $storage_obj->container,
                        $self->{path},
                        $storage_obj->saskey;
  my $r = system $command . " > /dev/null 2>&1";

  if ($r == 0) {
    _logging( "ok: $command" );
    return $storage_obj;
  } else {
    _logging( "NG: $command" );
    return undef;
  }
}

sub _logging {
  openlog __FILE__, q{pid,delay}, q{local0};
  setlogsock q{unix};
  syslog q{info}, shift // q{};
  closelog;
}

1;

