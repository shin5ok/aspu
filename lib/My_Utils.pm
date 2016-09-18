use strict;
use warnings;
package My_Utils 0.01 {

  use LWP::UserAgent;

  our $SLACK_BASE_URL = qq{http://uname.link/slack/};
  
  my $lwp = LWP::UserAgent->new;
     $lwp->timeout(10);

  sub post_to_myslack {
    my ($channel, $message) = @_;

    my $slack_url = $SLACK_BASE_URL . $channel;
    $lwp->post( $slack_url, { message => $message } );

  }

}
1;
