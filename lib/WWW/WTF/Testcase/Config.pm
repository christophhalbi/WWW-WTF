package WWW::WTF::Testcase::Config;
use Moose;
use File::Find::Rule;
use Config::Merged;
use Getopt::Long;
use common::sense;

has 'config_directory' => (
    is          => 'ro',
    isa         => 'Str',
    required    => 1,
);

has 'config' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub { {}; },
);

sub _extend_config_from_directory {
    my ($self, $path) = @_;

    my @config_files = File::Find::Rule
        ->file()
        ->name('*.yml')
        ->maxdepth(1)
        ->in($path);

    foreach my $config_file (@config_files) {
        my $config = Config::Any->load_files({
            files           => [ $config_file ],
            use_ext         => 1,
            flatten_to_hash => 1,
        });

        #stip path from config hash
        my $config = (values(%$config))[0];

        while (my ($key, $values) = each(%$config)) {
            push(@{ $self->config->{$key} }, @{ $values });
        }
    }
}


sub BUILD {
    my ($self) = @_;

    $self->_extend_config_from_directory($self->config_directory . '/default/');
    $self->_extend_config_from_directory($self->config_directory . '/local/');
}

sub get {
    my ($self, $key) = @_;

    return $self->config->{$key};
}


__PACKAGE__->meta->make_immutable;
1;
