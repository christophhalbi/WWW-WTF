package WWW::WTF::HTTPResource::Types::HTML::Tag::Attribute;

use common::sense;

use Moose;

use Test::LongString qw//;

has 'name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'content' => (
    is  => 'ro',
    isa => 'Str',
);

has 'exists' => (
    is       => 'ro',
    isa      => 'Bool',
    default  => sub { 1; },
);

sub contains_string {
    my ($self, $str, $description) = @_;

    $description = qq{Attribute contains "$str"} if not defined $description;

    return Test::LongString::contains_string($self->content, $str, $description);
}

1;
