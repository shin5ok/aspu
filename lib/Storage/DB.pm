use strict;
use warnings;

package Storage::DB 0.01;
use MongoDB;
use Storage::Config;

my $config = Storage::Config->get;

my $hostname; 
my $port    ;
my $db_name ;
my $collname;
my $username;
my $password;
{
  no strict 'refs';
  $hostname = $config->{mongodb}->{hostname} // q{localhost};
  $port     = $config->{mongodb}->{port}     // 27017;
  $db_name  = $config->{mongodb}->{dbname};
  $collname = $config->{mongodb}->{collname};
  $username = $config->{mongodb}->{user};
  $password = $config->{mongodb}->{password};
}

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
