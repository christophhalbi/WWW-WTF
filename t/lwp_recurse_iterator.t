
use common::sense;

use Test2::V0 '!meta';

use URI;

use WWW::WTF::UserAgent::LWP;

my $ua = WWW::WTF::UserAgent::LWP->new;

my $iterator = $ua->recurse(URI->new('http://hqvm-beta-1.atikon.io:9999/sitemap.xml'));

my @http_resources;

while (my $http_resource = $iterator->next) {

    push @http_resources, $http_resource;
}

is(scalar @http_resources, 2, 'iterator worked');

done_testing();
