use FindBin;
use lib "$FindBin::Bin/lib";
use Test2::V0 '!meta';
use Test2::Tools::Compare qw{ is };
use WWW::WTF::Testcase;

my $test = WWW::WTF::Testcase->new();

my $expected_config = {
    default_only => [ 'value1 '],
    merged_with_local => [ 'value1', 'value2', 'value3' ],
};

is(
    $test->config->get('default_only'),
    [ 'value1' ],
    'default only config'
);

is(
    $test->config->get('merged_with_local'),
    [ 'value1', 'value2', 'value3' ],
    'merged config'
);

done_testing();
