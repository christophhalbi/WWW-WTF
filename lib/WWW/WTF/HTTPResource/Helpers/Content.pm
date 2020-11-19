package WWW::WTF::HTTPResource::Helpers::Content;

use common::sense;

use Moose;

use Test::LongString qw//;

has 'content' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

sub contains_string {
    my ($self, $str, $description) = @_;

    $description = qq{Content contains "$str"} if not defined $description;

    return Test::LongString::contains_string($self->content, $str, $description);
}

sub contains_regex {
    my ($self, $regex, $description) = @_;

    $description = qq{Content is like "$regex"} if not defined $description;

    return Test::LongString::like_string($self->content, $regex, $description);
}

sub lacks_string {
    my ($self, $str, $description) = @_;

    $description = qq{Content lacks "$str"} if not defined $description;

    return Test::LongString::lacks_string($self->content, $str, $description);
}

sub lacks_regex {
    my ($self, $regex, $description) = @_;

    $description = qq{Content is unlike "$regex"} if not defined $description;

    return Test::LongString::unlike_string($self->content, $regex, $description);
}

1;
