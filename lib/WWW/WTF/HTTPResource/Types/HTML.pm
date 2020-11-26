package WWW::WTF::HTTPResource::Types::HTML;

use common::sense;

use Moose::Role;

use HTML::TokeParser;

has 'parser' => (
    is      => 'rw',
    isa     => 'HTML::TokeParser',
    lazy    => 1,
    builder => 'parse_content',
);

sub parse_content {
    my ($self) = @_;

    my $parser = HTML::TokeParser->new(doc => \$self->content) or die "Can't parse: $!";

    return $parser;
}

sub reset_parser {
    my ($self) = @_;

    $self->parser(
        $self->parse_content
    );
}

sub get_a_tags {
    my ($self, $o) = @_;

    my @tags;

    while (my $token = $self->parser->get_tag(qw/a/)) {
        next if $self->filtered($o, $token);

        my $text = $self->parser->get_trimmed_text('/a');
        $token->[4] = $text; # add content

        push @tags, $token;
    }

    $self->reset_parser;

    return @tags;
}

sub get_links {
    my ($self, $o) = @_;

    my @links;

    foreach my $token ($self->get_a_tags($o)) {
        push @links, URI->new($token->[1]->{href});
    }

    $self->reset_parser;

    return @links;
}

sub get_image_uris {
    my ($self, $o) = @_;

    my @links;

    while (my $token = $self->parser->get_tag(qw/img/)) {
        next if $self->filtered($o, $token);

        push @links, URI->new($token->[1]->{src});
    }

    $self->reset_parser;

    return @links;
}

sub get_headings {
    my ($self, $o) = @_;

    my @headings;

    while (my $token = $self->parser->get_tag(qw/h1 h2 h3 h4 h5 h6/)) {
        next if $self->filtered($o, $token);

        push @headings, $token->[0];
    }

    $self->reset_parser;

    return @headings;
}

sub filtered {
    my ($self, $o, $token) = @_;

    return 0 unless defined $o;

    return 0 unless exists $o->{filter};

    if (exists $o->{filter}->{attributes}) {

        my %attributes = %{ $o->{filter}->{attributes} };

        foreach my $attribute (keys %attributes) {
            return 1 unless (($token->[1]->{$attribute} // '') =~ m/$attributes{$attribute}/i);
        }
    }

    if (exists $o->{filter}->{external}) {

        my $href = $token->[1]->{href};
        my $base_uri = $self->request_uri->authority;

        return 1 unless defined $href;
        return 1 unless ($href =~ m/^http/);

        my $href_uri = URI->new($href);
        $href_uri->authority;

        return 1 if ($href_uri =~ m/$base_uri/);
    }

    return 0;
}

1;
