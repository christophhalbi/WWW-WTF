use inc::Module::Install;

name 'WWW-WTF';
version '1.0';

requires 'common::sense';
requires 'Cache::FastMmap';
requires 'Digest::SHA';
requires 'Export::Attrs';
requires 'HTML::TokeParser';
requires 'HTTP::Headers';
requires 'LWP::UserAgent';
requires 'Moose';
requires 'URI';
requires 'WWW::Mechanize';
requires 'WWW::WebKit2' => 0.127;
requires 'XML::Simple';

test_requires 'Plack';
test_requires 'Test2::Suite';

auto_install;
WriteAll;
