use strict;
use warnings;
package My_Utils 0.01 {

  use Sys::Syslog qw(:DEFAULT setlogsock);
  use LWP::UserAgent;
  use Exporter q(import);

  our @EXPORT_OK = qw( post_to_myslack logging );

  our $SLACK_BASE_URL = qq{http://uname.link/slack/};
  
  my $lwp;
  sub post_to_myslack {
    my ($channel, $message) = @_;

    my $lwp //= LWP::UserAgent->new;
       $lwp->timeout(10);

    my $slack_url = $SLACK_BASE_URL . $channel;
    $lwp->post( $slack_url, { message => $message } );

  }

  sub logging {
    openlog __FILE__, q{pid,delay}, q{local0};
    setlogsock q{unix};
    syslog q{info}, shift // q{};
    closelog;
  }

}
1;
