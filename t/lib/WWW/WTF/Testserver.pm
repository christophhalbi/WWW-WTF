package WWW::WTF::Testserver;
use Moose;
use common::sense;

use URI;

use Plack::Test;
use Plack::App::File;
$Plack::Test::Impl = 'Server';

use namespace::autoclean;

has 'server' => (
    is      => 'ro',
    isa     => 'Plack::Test::Server',
    default => sub {
        my $app = Plack::App::File->new(root => "t/testsite/")->to_app;
        return Plack::Test->create($app);
    },
);

has 'base_uri' => (
    is      => 'ro',
    isa     => 'URI',
    lazy    => 1,
    default => sub {
        URI->new('http://127.0.0.1:' . shift->server->port);
    },
);

sub uri_for {
    my ($self, $target) = @_;

    return URI->new($self->base_uri . $target);
}

__PACKAGE__->meta->make_immutable;
1;





