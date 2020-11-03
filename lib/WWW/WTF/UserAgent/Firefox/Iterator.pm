package WWW::WTF::UserAgent::Firefox::Iterator;

use common::sense;

use v5.12;

use Moose;

with 'WWW::WTF::UserAgent::Role::Iterator';

has 'ua' => (
    is       => 'ro',
    isa      => 'WWW::WTF::UserAgent::Firefox',
    required => 1,
);

__PACKAGE__->meta->make_immutable;

1;
