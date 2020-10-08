package WWW::WTF::HTTPResource::Texthtml;

use common::sense;

use Moose::Role;

use HTML::TokeParser;

sub get_links {
    my $self = shift;

    my @links;

    my $parser = HTML::TokeParser->new(\$self->content) or die "Can't parse: $!";

    while (my $token = $parser->get_tag(qw/a/)) {

        push @links, URI->new($token->[1]->{href});
    }

    return @links;
}

1;
