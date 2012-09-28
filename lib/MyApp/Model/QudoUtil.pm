package MyApp::Model::QudoUtil;
use strict;
use warnings;
use utf8;
use MyApp::Container;
use JSON::XS;

sub new { bless {}, +shift }

sub bulk_enqueue {
    my ($self,$jobs) = @_;

    my $qudo = container('qudo');
    my $dsn  = $qudo->shuffled_databases;
    my $db   = $qudo->manager->driver_for($dsn);

    $db->dbh->begin_work;
        for my $job (@$jobs) {
            $qudo->manager->enqueue(@$job, $dsn);
        }
    $db->dbh->commit;
}

sub retry_worker_error_log {
    my $self = shift;

    my @worker_error_log = container('db')->search('worker_error_log',{retried_fg => 0})->all;

    my @jobs = map {
        my $row = $_;
        [$row->funcname,{
            arg      => decode_json($row->arg),
            uniqkey  => $row->uniqkey,
            priority => $row->priority,
        }];
    } @worker_error_log;

    my @update_ids = map {$_->id} @worker_error_log;

    my $txn = container('db')->txn_scope;
        container('db')->update('worker_error_log',
            { retried_fg => 1 },
            { id => { 'in' => \@update_ids } }
        );

        $self->bulk_enqueue(\@jobs);
    $txn->commit;
}

1;

