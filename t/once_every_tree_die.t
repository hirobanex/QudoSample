use t::Utils;
use Test::More;
use MyApp::Container;
use MyApp::Worker::OnceEveryTreeDie;

init_db_qudo();

my $qudo = container('qudo');

subtest 'enqueue' => sub {
    $qudo->enqueue('MyApp::Worker::OnceEveryTreeDie',+{ arg => {hoge => 1}, });
    my (undef,$job_count) = %{$qudo->job_count()};
    is $job_count,1;
};
subtest 'work' => sub {
    $qudo->manager->register_abilities("MyApp::Worker::OnceEveryTreeDie");
    $qudo->manager->work_once;
    my (undef,$job_count) = %{$qudo->job_count()};
    is $job_count,0;
};

teardown_db_qudo();

done_testing;
