package t::Utils;
use strict;
use warnings;
use utf8;
use lib './t/';
use MyApp::Container;

sub import {
    my $caller = caller(0);

    for my $func (qw/
        init_db_qudo teardown_db_qudo 
    /) {
        no strict 'refs'; ## no critic.
        *{$caller.'::'.$func} = \&$func;
    }

    strict->import;
    warnings->import;
    utf8->import;
}

sub qudo_dbname { 
    container('conf')->{qudo_test_db_name};
}

sub teardown_db_qudo{
    system(
        'mysql',
        '-u'.container('conf')->{qudo}->{datasources}->[0]->{username},
        '-p'.container('conf')->{qudo}->{datasources}->[0]->{password},
        '-e'.'drop database '.qudo_dbname(),
    );
}

sub init_db_qudo(){
    teardown_db_qudo;

    my $db_qudo = qudo_dbname();
    my $user    = container('conf')->{qudo}->{datasources}->[0]->{username};
    my $pass    = container('conf')->{qudo}->{datasources}->[0]->{password};

    system "qudo --db=$db_qudo --user=$user --pass=$pass --rdbms=mysql";

    container('conf')->{qudo}->{datasources} = +[+{
        dsn      => 'dbi:mysql:'.$db_qudo,
        username => $user,
        password => $pass,
    }];

    MyApp::Container->remove('qudo');
}

1;
