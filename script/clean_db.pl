#!/usr/bin/env perl
use MyApp::Container;

my $user    = container('conf')->{qudo}->{datasources}->[0]->{username};
my $pass    = container('conf')->{qudo}->{datasources}->[0]->{password};

system("mysql -u$user -p$pass -e'truncate table func;' my_app_qudo");
system("mysql -u$user -p$pass -e'truncate table job;' my_app_qudo");
system("mysql -u$user -p$pass -e'truncate table job_status;' my_app_qudo");
system("mysql -u$user -p$pass -e'truncate table exception_log;' my_app_qudo");
system("mysql -u$user -p$pass -e'truncate table worker_error_log;' my_app");
