use FindBin;
use lib "$FindBin::Bin/lib";
use Test2::V0 '!meta';
use Test2::Require::Module 'WWW::WebKit2';
use WWW::WTF::Test;

my $test = WWW::WTF::Test->new();

$test->run_test(sub {
    my ($self) = @_;

    my $http_resource = $self->ua_firefox->get($self->uri_for('/index.html'));

    my @links = $http_resource->get_links();

    is(scalar @links, 2);
});

done_testing();
