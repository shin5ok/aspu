#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use opts;
use File::Basename;
use Parallel::ForkManager;
use lib qq($FindBin::Bin/./lib);
require Storage::Copy;
require Storage::DB;
use My_Utils qw(logging post_to_myslack);

opts my $parallel => { isa => 'Int', default => 1 },
     my $debug    => { isa => 'Bool' };

my $pf = Parallel::ForkManager->new( $parallel );
my $mongodb = Storage::DB->new;

_PF_:
while (my $data = <STDIN>) {
  $pf->start and next _PF_;
  my ($path, $md5) = $data =~ /^(\S+)\s+(\S*)/;
  my $obj = Storage::Copy->new( $path, $md5 );
  if (my $storage_obj = $obj->copy) {
    $mongodb->upsert(
      "path",
      +{
        path      => $path,
        storage   => $storage_obj->account,
        container => $storage_obj->container,
        filename  => basename $path,
      },
    );
  } else {
    post_to_myslack("kawano", "fail: $path");
  }
  $pf->finish;
}

$pf->wait_all_children;

