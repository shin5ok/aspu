use strict;
use warnings;
package ASU;
use Class::Accessor::Lite ( rw => [qw( account container saskey )] );
use JSON;

sub new {
  my ($class, $params) = @_;
  bless $params, $class;
}

1;

