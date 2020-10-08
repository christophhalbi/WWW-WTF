
use common::sense;

use Test2::V0 '!meta';

use URI;

use WWW::WTF::UserAgent::WebKit2;

my $ua = WWW::WTF::UserAgent::WebKit2->new;

my $http_resource = $ua->get(URI->new('http://hqvm-beta-1.atikon.io:9999/js_external_requests.html'));

done_testing();
