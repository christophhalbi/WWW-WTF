package WWW::WTF::UserAgent::WebKit2::Browser;

use common::sense;

use Moose;

extends 'WWW::WebKit2';

has 'callbacks' => (
    is      => 'ro',
    isa     => 'HashRef[CodeRef]',
    lazy    => 1,
    default => sub { {} },
);

before handle_resource_request => sub {
    my ($self, $view, $resource, $request) = @_;

    if (exists $self->callbacks->{handle_resource_request}) {
        $self->callbacks->{handle_resource_request}->($view, $resource, $request);
    }
};

__PACKAGE__->meta->make_immutable;

1;
