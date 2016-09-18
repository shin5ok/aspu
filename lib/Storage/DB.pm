use strict;
use warnings;

package Storage::DB 0.01;
use MongoDB;

our $hostname = 'localhost';
our $port     = 27017;
our $db_name  = 'azure_storage';
our $collname = 'store';
our $username = $ENV{MONGODB_USER};
our $password = $ENV{MONGODB_PASSWORD};

sub new {
  my ($class, $params) = @_;
  my %auth = (
    host => qq{$hostname:$port},
    db_name  => $db_name,
  );
  if (defined $username and defined $password) {
    $auth{username} = $username,
    $auth{password} = $password,
  }
  my $obj;
  local $@;
  eval {
    my $client = MongoDB::MongoClient->new( %auth );
    my $database = $client->get_database($db_name);
    my $collection = $database->get_collection($collname);
    $obj = bless +{
      mongodb => $collection,
    }, $class;
  };
  if ($@) {
    warn $@, "\n";
  }

  return $obj;
}

sub upsert {
  my ($self, $key, $data) = @_;
  return if not $self->{mongodb};
  $self->{mongodb}->update({ $key => $data->{$key} }, { '$set' => $data }, { upsert => 1, multiple => 0, });
}

1;
