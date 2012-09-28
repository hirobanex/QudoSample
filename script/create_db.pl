#!/usr/bin/env perl
use strict;
use warnings;
use MyApp::Container;

my $user    = container('conf')->{qudo}->{datasources}->[0]->{username};
my $pass    = container('conf')->{qudo}->{datasources}->[0]->{password};

system("mysql -u$user -p$pass -e'create database my_app;'");
system("mysql -u$user -p$pass -e'
CREATE TABLE worker_error_log(
    id         int(10) unsigned    NOT NULL auto_increment,
    funcname   varchar(255) binary NOT NULL,
    arg        mediumblob,
    uniqkey    varchar(255)        DEFAULT NULL,
    priority   int(10) unsigned    DEFAULT NULL,
    retried_fg tinyint(1) unsigned NOT NULL default 0,
    updated_at timestamp           NOT NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,

    PRIMARY KEY    (id),
    KEY funcname   (funcname),
    KEY retried_fg (retried_fg)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
' my_app;");

system("qudo --db=my_app_qudo --user=$user --pass=$pass --rdbms=mysql --use_innodb");


