#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib qq($FindBin::Bin/./lib);
use Storage_Copy;

while (my $data = <STDIN>) {
  my ($path, $md5) = $data =~ /^(\S+)\s+(\S*)/;
  my $obj = Storage_Copy->new( $path, $md5 );
  $obj->copy;
}


