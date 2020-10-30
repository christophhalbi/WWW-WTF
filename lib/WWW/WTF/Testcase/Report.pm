package WWW::WTF::Testcase::Report;
use Moose;
use common::sense;
use Test2::V0 '!meta';

sub success {
    my ($self, $uri, $o) = @_;

    my ($package, $testcase) = caller();

    pass({
        uri         => $uri,
        testcase    => $testcase,
    });
}

sub failure {
    my ($self, $uri, $o) = @_;

    my ($package, $testcase) = caller();

    fail({
        uri         => $uri,
        testcase    => $testcase,
    });

}


__PACKAGE__->meta->make_immutable;
1;
