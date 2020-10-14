use common::sense;

use Test2::V0 '!meta';
use URI;

use Plack::Test;
use Plack::App::File;

$Plack::Test::Impl = 'Server';
my $app = Plack::App::File->new(root => "t/testsite/")->to_app;
my $test = Plack::Test->create($app);

my $base_url = URI->new('http://127.0.0.1:' . $test->port);

use WWW::WTF::UserAgent::LWP;
my $ua = WWW::WTF::UserAgent::LWP->new;
my $http_resource = $ua->get(URI->new($base_url . '/index.html'));
my @links = $http_resource->get_links();

is(scalar @links, 1);

done_testing();
