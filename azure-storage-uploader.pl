#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use opts;
use File::Basename;
use Parallel::ForkManager;
use lib qq($FindBin::Bin/./lib);
require ASU::Copy;
require ASU::DB;
use My_Utils qw( logging post_to_myslack singlelock sendmail );

our $VERSION = q(0.01);

logging sprintf "%s %s", $0, (join " ", @ARGV);

opts my $parallel => { isa => 'Int', default => 1 },
     my $slack    => { isa => 'Str'  },
     my $mail     => { isa => 'Str'  },
     my $debug    => { isa => 'Bool' };

my $pf = Parallel::ForkManager->new( $parallel );

chdir "/";

singlelock(1);

my $mongodb = ASU::DB->new;

_PF_:
while (my $data = <STDIN>) {
  $pf->start and next _PF_;
  my ($path, $md5) = $data =~ /^(\S+)\s+(\S*)/;
  # For now, values of md5 would not be used
  my $obj = ASU::Copy->new( $path, $md5 );
  if (my $storage_obj = $obj->copy) {
    $mongodb->upsert(
      "path",
      +{
        path      => $path,
        storage   => $storage_obj->account,
        container => $storage_obj->container,
        filename  => basename $path,
      },
    ) or logging "DB store fail: $path";
  } else {
     my $message = "fail: $path";
     post_to_myslack($slack, $message) if $slack;
     sendmail($mail,$message)          if $mail;
  }
  $pf->finish;
}

$pf->wait_all_children;

END {
  singlelock(0);
};