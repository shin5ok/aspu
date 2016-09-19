use strict;
use warnings;
package My_Utils 0.01 {

  use Sys::Syslog qw(:DEFAULT setlogsock);
  use File::Basename;
  use LWP::UserAgent;
  use Exporter q(import);

  our @EXPORT_OK = qw( post_to_myslack logging );

  our $SLACK_BASE_URL = qq{http://uname.link/slack/};
  
  my $lwp;
  sub post_to_myslack {
    my ($channel, $message) = @_;

    my $lwp //= do {
                     LWP::UserAgent->new;
                     $lwp->timeout(10);
                     $lwp;
                   };

    my $slack_url = $SLACK_BASE_URL . $channel;
    $lwp->post( $slack_url, { message => $message } );
  }

  sub logging {
    my $caller = caller;
    openlog $caller, q{pid,delay}, q{local1};
    setlogsock q{unix};
    syslog q{info}, shift // q{};
    closelog;
  }

}
1;
