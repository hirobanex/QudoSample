return +{
    qudo_test_db_name => 'my_app_qudo_test',

    qudo => +{
        datasources       => +[
            +{
                dsn      => 'dbi:mysql:my_app_qudo;',
                username => 'root',
                password => 'test',
            },
        ],
        default_hooks     => [qw/
            Qudo::Hook::Serialize::JSON
            Qudo::Hook::ForceQuitJob
            MyApp::Worker::Hook::NotifyReachMaxRetry
        /],
        manager_abilities => [qw/
            MyApp::Worker::Simple
            MyApp::Worker::Die
            MyApp::Worker::OnceEveryTreeDie
            MyApp::Worker::Sleeper
        /],
    },
};

