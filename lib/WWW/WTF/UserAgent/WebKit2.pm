package WWW::WTF::UserAgent::WebKit2;

use common::sense;

use Moose;

use HTTP::Headers;
use WWW::WebKit2;

use WWW::WTF::HTTPResource;

extends 'WWW::WTF::UserAgent';

has 'ua' => (
    is      => 'ro',
    isa     => 'WWW::WebKit2',
    lazy    => 1,
    default => sub {

        my $wkit = WWW::WebKit2->new();

        $wkit->init;

        return $wkit;
    },
);

sub get {
    my ($self, $uri) = @_;

    confess "$uri is not an URI object" unless (ref($uri) =~ /^URI::https?$/);

    $self->ua->open($uri->as_string);

    my $resource = $self->ua->view->get_main_resource();

    my $response = $resource->get_response;

    my $http_resource = WWW::WTF::HTTPResource->new(
        headers => HTTP::Headers->new( Content_Type => $response->get_mime_type ),
        content => $self->ua->get_html_source,
    );

    return $http_resource;
}

__PACKAGE__->meta->make_immutable;

1;
