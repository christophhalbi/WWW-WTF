package WWW::WTF::Testcase;
use Moose;
use common::sense;

use Getopt::Long;
use URI;

use Test2::Tools::Subtest qw/subtest_buffered/;

use WWW::WTF::UserAgent::LWP;
use WWW::WTF::UserAgent::WebKit2;
use WWW::WTF::Testcase::Report;
use WWW::WTF::Testcase::Config;

use namespace::autoclean;

#command line arguments
has 'cli_arguments' => (
    is => 'ro',
    isa => 'HashRef',
    lazy => 1,
    default => sub {
        my $base_url            = undef;
        my $config_directory    = 't/conf.d/';

        GetOptions (
            "base_url=s"            => \$base_url,
            "config_directory=s"    => \$config_directory,
        );

        return {
            base_url            => URI->new($base_url),
            config_directory    => $config_directory,
        };
    },
);

has 'base_uri' => (
    is      => 'ro',
    isa     => 'URI',
    lazy    => 1,
    default => sub {
        URI->new(shift->cli_arguments->{base_url});
    },
);

#User Agents
has 'ua_lwp' => (
    is      => 'ro',
    lazy    => 1,
    isa     => 'WWW::WTF::UserAgent::LWP',
    default => sub { WWW::WTF::UserAgent::LWP->new(); },
);

has 'ua_webkit2' => (
    is      => 'ro',
    lazy    => 1,
    isa     => 'WWW::WTF::UserAgent::WebKit2',
    default => sub { WWW::WTF::UserAgent::WebKit2->new(); },
);


#Report
has 'report' => (
    is      => 'ro',
    lazy    => 1,
    isa     => 'WWW::WTF::Testcase::Report',
    default => sub { WWW::WTF::Testcase::Report->new(); },
);

#Config
has 'config' => (
    is      => 'ro',
    lazy    => 1,
    isa     => 'WWW::WTF::Testcase::Config',
    default => sub {
        WWW::WTF::Testcase::Config->new(
            config_directory => shift->cli_arguments->{config_directory}
        );
    },
);

#Helpers
sub uri_for {
    my ($self, $target) = @_;

    return URI->new($self->base_uri . $target);
}

sub run_test {
    my ($self, $test) = @_;

    $test->($self);

    $self->report->done;
}

sub run_subtest {
    my ($self, $name, $test) = @_;

    subtest_buffered($name, $test);
}

__PACKAGE__->meta->make_immutable;
1;
