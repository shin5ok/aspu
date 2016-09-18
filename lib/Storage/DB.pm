use strict;
use warnings;

package Storage::DB 0.01;
use MongoDB;

our $hostname = 'localhost';
our $port     = 27017;
our $db       = 'storage';
our $username = $ENV{MONGODB_USER};
our $password = $ENV{MONGODB_PASSWORD};

sub new {
  my ($class, $params) = @_;
  my %auth = (
    host => qq{$hostname:$port},
    db_name  => $db,
    username => $username,
    password => $password,
  );
  my $obj;
  local $@;
  eval {
    my $client = MongoDB::MongoClient->new( %auth );
    $obj = bless +{
      mongodb => $client,
    }, $class;
  };
  if ($@) {
    warn $@, "\n";
  }

  return $obj;
}

sub upsert {

}

1;
