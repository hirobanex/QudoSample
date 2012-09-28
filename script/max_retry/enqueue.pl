#!/usr/bin/env perl
use strict;
use warnings;
use MyApp::Container qw/api/;

container('qudo')->enqueue('MyApp::Worker::Die',{
    arg => { Die => 1, },
});
