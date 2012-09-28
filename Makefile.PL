use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Kurenai',
    VERSION_FROM  => 'lib/Kurenai.pm',
    PREREQ_PM     => {
        'Object::Container::Exporter' => '0.03',
        'JSON::XS' => '2.32',
        'DBI' => '1.617',
        'Teng' => '0.15',
        'Teng::Schema::Loader',
        'Qudo' => '0.0213',
        'Qudo::Parallel::Manager' => '0.06',
    },
    MIN_PERL_VERSION => '5.008001'
);

test_requires 't::Utils';
WriteAll;
