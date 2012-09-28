package MyApp::Worker::Hook::NotifyReachMaxRetry;
use strict;
use warnings;
use utf8;
use base 'Qudo::Hook';
use MyApp::Container;
use JSON::XS;

sub hook_point { 'post_work' }

sub load {
    my ($class, $klass) = @_;

    $klass->hooks->{post_work}->{'notify_reach_max_retry'} = sub {
        my $job = shift;

        if ($job->is_failed && ( $job->funcname->max_retries <= ($job->retry_cnt) )) {
            container('db')->insert('worker_error_log',{
                funcname => $job->funcname,
                arg      => encode_json($job->arg),
                uniqkey  => $job->uniqkey,
                priority => $job->priority + 100, #失敗している時点で再度の実行の優先順位は高いはず
            });

            #メール飛ばしても良い
        }
    };
}

sub unload {
    my ($class, $klass) = @_;

    delete $klass->hooks->{post_work}->{'notify_reach_max_retry'};
}
1;
