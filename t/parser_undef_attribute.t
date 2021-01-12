use FindBin;
use lib "$FindBin::Bin/lib";
use Test2::V0 '!meta';
use WWW::WTF::Test;

my $test = WWW::WTF::Test->new();

$test->run_test(sub {
    my ($self) = @_;

    my $http_resource = $self->ua_lwp->get($self->uri_for('/index.html'));
    my @a_tags = $http_resource->get_a_tags;

    is($a_tags[0]->attribute('href')->name, 'href', 'validate existing attribute name');
    is($a_tags[0]->attribute('href')->content, '/index.html', 'validate existing attribute content');
    is($a_tags[0]->attribute('href')->exists, '1', 'validate existing attribute exists flag');


    is($a_tags[0]->attribute('dummy')->name, 'undef', 'validate absent attribute name');
    is($a_tags[0]->attribute('dummy')->content, '', 'validate absent attribute content returns empty string');
    is($a_tags[0]->attribute('dummy')->exists, '0', 'validate absent attribute exists flag');
});

done_testing();
