package WWW::WTF::UserAgent::Firefox;

use common::sense;

use Moose;

use Firefox::Marionette;

use WWW::WTF::HTTPResource;
use WWW::WTF::UserAgent::Firefox::Iterator;

extends 'WWW::WTF::UserAgent';

has 'ua' => (
    is      => 'ro',
    isa     => 'Firefox::Marionette',
    lazy    => 1,
    default => sub {
        my $self = shift;

        my $firefox = Firefox::Marionette->new;

        return $firefox;
    },
);

has 'callbacks' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub { {} },
);

sub get {
    my ($self, $uri) = @_;

    confess "$uri is not an URI object" unless (ref($uri) =~ /^URI::https?$/);

    $self->ua->go($uri->as_string);

    my $http_resource = WWW::WTF::HTTPResource->new(
        #headers     => HTTP::Headers->new( Content_Type => $response->get_mime_type ),
        content     => $self->ua->html,
        #successful  => ($response->get_status_code =~ m/^2\d\d$/ ? 1 : 0),
        request_uri => $uri,
    );

    return $http_resource;
}

sub recurse {
    my ($self, $sitemap_uri) = @_;

    confess "$sitemap_uri is not an URI object" unless (ref($sitemap_uri) =~ /^URI::https?$/);

    return WWW::WTF::UserAgent::Firefox::Iterator->new( sitemap_uri => $sitemap_uri, ua => $self );
}

__PACKAGE__->meta->make_immutable;

1;
