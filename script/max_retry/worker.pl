#!/usr/bin/env perl
use strict;
use warnings;
use MyApp::Container;
use MyApp::Worker::Die;

container('qudo')->manager->register_abilities('MyApp::Worker::Die');

container('qudo')->work();
