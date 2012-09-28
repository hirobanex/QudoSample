#!/usr/bin/env perl
use strict;
use warnings;
use MyApp::Container;
use MyApp::Worker::Simple;

container('qudo')->manager->register_abilities('MyApp::Worker::Simple');

container('qudo')->work();
