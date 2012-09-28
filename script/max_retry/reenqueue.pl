#!/usr/bin/env perl
use strict;
use warnings;
use MyApp::Container qw/model/;

model('QudoUtil')->retry_worker_error_log;
