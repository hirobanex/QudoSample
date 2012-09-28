package MyApp::Container;
use strict;
use warnings;
use Object::Container::Exporter -base;
use File::Spec;
use File::Basename qw(dirname);

register conf => sub {
    my $self = shift;
    my $root_dir = File::Spec->rel2abs(File::Spec->catdir(dirname(__FILE__), '../../'));
    my $config = do "$root_dir/config.pl";
};

register db => sub {
    my $self = shift;

    $self->load_class('DBI');
    $self->load_class('Teng');
    $self->load_class('Teng::Schema::Loader');

    my $dbh = DBI->connect("dbi:mysql:my_app", 'root', 'test', +{
        Callbacks => {
            connected => sub {
                my $conn = shift;
                $conn->do(<<EOF);
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
EOF
                return;
            },
        },
    });

    Teng::Schema::Loader->load(
        dbh => $dbh,
        namespace => 'MyApp::Model::DB'
    );
};

register qudo => sub {
    my $self = shift;

    $self->load_class('Qudo');

    Qudo->new(
        databases     => $self->get('conf')->{qudo}->{datasources},
        default_hooks => $self->get('conf')->{qudo}->{default_hooks},
    );
};

register qudo_parallel_manager => sub {
    my $self = shift;

    $self->load_class('Qudo::Parallel::Manager');

    Qudo::Parallel::Manager->new(
        databases              => $self->get('conf')->{qudo}->{datasources},
        manager_abilities      => $self->get('conf')->{qudo}->{manager_abilities},
        default_hooks          => $self->get('conf')->{qudo}->{default_hooks},
        work_delay             => 1,
        max_workers            => 5,
        min_spare_workers      => 5,
        max_spare_workers      => 5,
        max_request_par_chiled => 5,
        auto_load_worker       => 1,
        admin                  => 0,
        debug                  => 0,
    );
};

1;
