use common::sense;

use FindBin;
use lib "$FindBin::Bin/lib";

use WWW::WTF::Testserver;
my $s = WWW::WTF::Testserver->new();

use Test2::V0 '!meta';
use URI;

use WWW::WTF::UserAgent::LWP;
my $ua = WWW::WTF::UserAgent::LWP->new;

my $http_resource = $ua->get($s->uri_for('/index.html'));
my @links = $http_resource->get_links();

is(scalar @links, 1);

done_testing();
