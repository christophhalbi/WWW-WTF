use FindBin;
use lib "$FindBin::Bin/lib";
use Test2::V0 '!meta';
use WWW::WTF::Test;

my $test = WWW::WTF::Test->new();

$test->run_test(sub {
    my ($self) = @_;

    my $http_resource = $self->ua_lwp->get($self->uri_for('/index.html'));
    my @links = $http_resource->get_links({
        filter => {
            attributes => {
                title => 'foo',
            },
        },
    });

    is(scalar @links, 1);
    is($links[0]->uri->as_string, '/foo.html');

    @links = $http_resource->get_links({
        filter => {
            attributes => {
                title => 'foo',
                href  => 'foo',
            },
        },
    });

    is(scalar @links, 1);
    is($links[0]->uri->as_string, '/foo.html', 'combine filters');

    @links = $http_resource->get_links({
        filter => {
            attributes => {
                title => 'foo',
                href  => 'bar',
            },
        },
    });

    is(scalar @links, 0);

    my $http_resource_pdf = $self->ua_lwp->get($self->uri_for('/pdf.html'));
    my @links_pdf = $http_resource_pdf->get_links({
        filter => {
            attributes => {
                href => qr!\.pdf$!,
            },
        },
    });

    is(scalar @links_pdf, 1);
    is($links_pdf[0]->uri->as_string, '/letter.pdf');
});

done_testing();
