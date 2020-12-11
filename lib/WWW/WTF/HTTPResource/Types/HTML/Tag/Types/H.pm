package WWW::WTF::HTTPResource::Types::HTML::Tag::Types::H;

use common::sense;

use Moose::Role;

has 'level' => (
    is      => 'ro',
    isa     => 'Int',
    lazy    => 1,
    default => sub {
        return substr shift->name, 1;
    },
);

1;
