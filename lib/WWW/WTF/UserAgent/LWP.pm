package WWW::WTF::UserAgent::LWP;

use common::sense;

use Moose;

use LWP::UserAgent;

use WWW::WTF::HTTPResource;

extends 'WWW::WTF::UserAgent';

has 'ua' => (
    is      => 'ro',
    isa     => 'LWP::UserAgent',
    lazy    => 1,
    default => sub {

        return LWP::UserAgent->new( timeout => 10 );
    },
);

sub get {
    my ($self, $uri) = @_;

    confess "$uri is not an URI object" unless (ref($uri) =~ /^URI::https?$/);

    my $response = $self->ua->get($uri->as_string);

    return $response;
}

sub recurse {
    my ($self, $uri) = @_;

    confess "$uri is not an URI object" unless (ref($uri) =~ /^URI::https?$/);

    my $response = $self->get($uri);

    my @http_resources;

    my $http_resource = WWW::WTF::HTTPResource->new(
        headers => $response->headers,
        content => $response->content,
    );

    push @http_resources, $http_resource;

    return @http_resources;
}

__PACKAGE__->meta->make_immutable;

1;
