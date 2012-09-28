#!/usr/bin/env perl
use strict;
use warnings;
use MyApp::Container qw/api/;

container('qudo')->enqueue('MyApp::Worker::Simple',{
    arg => { foo => 4, bar => 2, },
});
