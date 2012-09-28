package MyApp::Worker::OnceEveryTreeDie;
use strict;
use warnings;
use Data::Dumper;
use base 'Qudo::Worker';

sub set_job_status { 1 }
sub max_retries    { 5 } #リトライする回数
sub retry_delay    { 5 } #リトライするときにあける間隔の秒数

sub work {
    my ($class, $job) = @_;
    # -ここはホントは別クラスにしたほうがテストしやすい--------
    if (int(rand(3)) == 0) {
        die "error!!";
    }else{
        print "success!!\n";
        warn Dumper $job->arg;
    }
    # ---------------------------------------------------------
    $job->completed;
}

1;
