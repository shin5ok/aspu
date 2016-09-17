package Storage;
use Class::Accessor::Lite ( rw => [qw( account container saskey )] );
use JSON;
use Data::Dumper;

sub new {
  my ($class, $params) = @_;
  warn Dumper $params;
  bless $params, $class;
}

1;

