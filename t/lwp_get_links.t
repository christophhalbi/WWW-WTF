
use common::sense;

use Test2::V0 '!meta';

use URI;

use WWW::WTF::UserAgent::LWP;

my $ua = WWW::WTF::UserAgent::LWP->new;

my @http_resources = $ua->recurse(URI->new('http://hqvm-beta-1.atikon.io:9999/index.html'));

foreach my $http_resource (@http_resources) {

    my @links = $http_resource->get_links();

    foreach my $link (@links) {

        is(
            $link->scheme, 'https',
            "URL " . $link . ' is HTTPS (found on ' . $ua->uri .')',
        );
    }
}

done_testing();
