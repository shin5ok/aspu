#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use Parallel::ForkManager;
use lib qq($FindBin::Bin/./lib);
use Storage_Copy;

my $parallel = shift // 1;
my $pf = Parallel::ForkManager->new( $parallel );

_PF_:
while (my $data = <STDIN>) {
  $pf->start and next _PF_;
  my ($path, $md5) = $data =~ /^(\S+)\s+(\S*)/;
  my $obj = Storage_Copy->new( $path, $md5 );
  $obj->copy;
  $pf->finish;
}
$pf->wait_all_children;

