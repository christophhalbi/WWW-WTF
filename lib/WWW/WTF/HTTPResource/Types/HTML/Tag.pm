package WWW::WTF::HTTPResource::Types::HTML::Tag;

use common::sense;

use Moose;

use List::Util qw(first);
use Test::LongString qw//;

has 'name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'content' => (
    is          => 'ro',
    isa         => 'Str',
);

has 'line' => (
    is  => 'ro',
    isa => 'Int',
);

has 'tag_types' => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
    default  => sub {
        {
            'a'   => 'A',
            'img' => 'Img',
            'h1'  => 'H',
            'h2'  => 'H',
            'h3'  => 'H',
            'h4'  => 'H',
            'h5'  => 'H',
            'h6'  => 'H',
        }
    },
);

has 'attributes' => (
    is  => 'ro',
    isa => 'ArrayRef[WWW::WTF::HTTPResource::Types::HTML::Tag::Attribute]',
);

sub BUILD {
    my $self = shift;

    my $tag_name = lc($self->name);

    if (exists $self->tag_types->{$tag_name}) {
        Moose::Util::apply_all_roles($self, 'WWW::WTF::HTTPResource::Types::HTML::Tag::Types::' . $self->tag_types->{$tag_name});
    }
}

sub attribute {
    my ($self, $name) = @_;

    my $attribute = first { $_->name eq $name } @{ $self->attributes };

    return defined $attribute
        ? $attribute
        : WWW::WTF::HTTPResource::Types::HTML::Tag::Attribute->new( name => 'undef', content => '', exists => 0 );
}

sub contains_string {
    my ($self, $str, $description) = @_;

    $description = qq{Tag contains "$str"} if not defined $description;

    return Test::LongString::contains_string($self->content, $str, $description);
}

1;
