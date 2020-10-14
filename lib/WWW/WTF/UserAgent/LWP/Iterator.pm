package WWW::WTF::UserAgent::LWP::Iterator;

use common::sense;

use v5.12;

use Moose;

use XML::Simple;

has 'sitemap_uri' => (
    is       => 'ro',
    isa      => 'URI',
    required => 1,
);

has 'ua' => (
    is       => 'ro',
    isa      => 'WWW::WTF::UserAgent::LWP',
    required => 1,
);

has 'locations' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,
    default => sub { [] },
);

sub BUILD {
    my $self = shift;

    my $http_resource = $self->ua->get($self->sitemap_uri);

    my $data = XMLin($http_resource->content);

    push @{ $self->locations }, URI->new($_->{loc}) foreach @{ $data->{url} };
}

sub next {
    my $self = shift;

    my $next = pop @{ $self->locations };

    return unless $next;

    return $self->ua->get($next);
}

__PACKAGE__->meta->make_immutable;

1;