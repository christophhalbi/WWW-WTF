package WWW::WTF::HTTPResource;

use common::sense;

use v5.12;

use Moose;

has 'headers' => (
    is       => 'ro',
    isa      => 'HTTP::Headers',
    required => 1,
);

has 'content' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

sub BUILD {
    my $self = shift;

    my $content_type = $self->headers->content_type;

    $content_type =~ s/[^\w]//gm;

    $content_type = ucfirst $content_type;

    Moose::Util::apply_all_roles($self, 'WWW::WTF::HTTPResource::' . $content_type);
}

sub get_links { ... }

__PACKAGE__->meta->make_immutable;

1;
