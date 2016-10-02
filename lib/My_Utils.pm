use strict;
use warnings;
package My_Utils 0.01 {

  use Sys::Syslog qw(:DEFAULT setlogsock);
  use File::Basename;
  use LWP::UserAgent;
  use JSON;
  use Exporter q(import);

  our @EXPORT_OK = qw( post_to_myslack logging );

  # URL of slack api for incoming webhook
  our $SLACK_API = $ENV{MY_SLACK_API};
  our $debug     = exists $ENV{DEBUG} ? $ENV{DEBUG} : undef;
  
  my $lwp;
  sub post_to_myslack {
    my ($channel, $text) = @_;

    if (not defined $SLACK_API) {
      return;
    }

    my $lwp //= do {
                     my $lwp = LWP::UserAgent->new;
                     $lwp->timeout(10);
                     $lwp;
                   };

    my $json = encode_json {"channel" => $channel, "username" => "webhookbot", "text" => $text, "icon_emoji"=>":ghost"};
    my $response = $lwp->post( $SLACK_API, { payload => $json } );
    return $response->code;
  }

  sub logging {
    my $caller = caller;
    my $log = shift;
    openlog $caller, q{pid,delay}, q{local1};
    setlogsock q{unix};
    syslog q{info}, $log // q{};
    closelog;
    if ($debug) {
      print {*STDERR} $log, "\n";
    }
  }

}
1;
