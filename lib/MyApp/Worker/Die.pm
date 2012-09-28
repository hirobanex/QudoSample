package MyApp::Worker::Die;
use strict;
use warnings;
use Data::Dumper;
use base 'Qudo::Worker';

#qudoの実行結果を記録するjob_statusテーブルに結果を入力するかどうか
sub set_job_status { 1 }

sub max_retries    { 4 } #リトライする回数
sub retry_delay    { 2 } #リトライするときにあける間隔の秒数
sub grab_for       { 5 } #他のワーカーが実行できないようにロックする秒数

sub work {
    my ($class, $job) = @_;
    # -ここはホントは別クラスにしたほうがテストしやすい--------
    die 'error!!';
    # ---------------------------------------------------------
    $job->completed;
}

1;
