#!/usr/bin/env perl
use strict;
use warnings;
use MyApp::Container;
use MyApp::Worker::OnceEveryTreeDie;

container('qudo')->manager->register_abilities('MyApp::Worker::OnceEveryTreeDie');

container('qudo')->work();
