#!/usr/bin/env perl
use strict;
use warnings;
use MyApp::Container qw/api/;

for (1..10) {
    container('qudo')->enqueue('MyApp::Worker::OnceEveryTreeDie',{
        arg => { bar => 1, },
    });
}
