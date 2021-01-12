package WWW::WTF::HTTPResource::Types::HTML::Parser;

use strict;

require HTML::PullParser;
our @ISA = qw(HTML::PullParser);
our $VERSION = '3.75';

use Carp ();
use HTML::Entities qw(decode_entities);
use HTML::Tagset ();

my %ARGS =
(
    start       => "'S',tagname,attr,attrseq,text,line",
    end         => "'E',tagname,text",
    text        => "'T',text,is_cdata",
    process     => "'PI',token0,text",
    comment     => "'C',text",
    declaration => "'D',text",

    # options that default on
    unbroken_text => 1,
);


sub new
{
    my $class = shift;
    my %cnf;

    if (@_ == 1) {
        my $type = (ref($_[0]) eq "SCALAR") ? "doc" : "file";
        %cnf = ($type => $_[0]);
    }
    else {
        unshift @_, (ref($_[0]) eq "SCALAR") ? "doc" : "file" if(scalar(@_) % 2 == 1);
        %cnf = @_;
    }

    my $textify = delete $cnf{textify} || {img => "alt", applet => "alt"};

    my $self = $class->SUPER::new(%ARGS, %cnf) || return undef;

    $self->{textify} = $textify;
    $self;
}


sub get_tag
{
    my $self = shift;
    my $token;
    while (1) {
        $token = $self->get_token || return undef;
        my $type = shift @$token;
        next unless $type eq "S" || $type eq "E";
        substr($token->[0], 0, 0) = "/" if $type eq "E";
        return $token unless @_;
        for (@_) {
            return $token if $token->[0] eq $_;
        }
    }
}


sub _textify {
    my($self, $token) = @_;
    my $tag = $token->[1];
    return undef unless exists $self->{textify}{$tag};

    my $alt = $self->{textify}{$tag};
    my $text;
    if (ref($alt)) {
        $text = &$alt(@$token);
    } else {
        $text = $token->[2]{$alt || "alt"};
        $text = "[\U$tag]" unless defined $text;
    }
    return $text;
}

sub get_text
{
    my $self = shift;
    my @text;
    while (my $token = $self->get_token) {
        my $type = $token->[0];
        if ($type eq "T") {
            my $text = $token->[1];
            decode_entities($text) unless $token->[2];
            push(@text, $text);
        } elsif ($type =~ /^[SE]$/) {
            my $tag = $token->[1];
            if ($type eq "S") {
                if (defined(my $text = _textify($self, $token))) {
                    push(@text, $text);
                    next;
                }
            } else {
                $tag = "/$tag";
            }
            if (!@_ || grep $_ eq $tag, @_) {
                 $self->unget_token($token);
                 last;
            }
            push(@text, " ")
                if $tag eq "br" || !$HTML::Tagset::isPhraseMarkup{$token->[1]};
        }
    }
    join("", @text);
}

sub get_trimmed_text
{
    my $self = shift;
    my $text = $self->get_text(@_);
    $text =~ s/^\s+//; $text =~ s/\s+$//; $text =~ s/\s+/ /g;
    $text;
}

sub get_phrase {
    my $self = shift;
    my @text;
    while (my $token = $self->get_token) {
        my $type = $token->[0];
        if ($type eq "T") {
            my $text = $token->[1];
            decode_entities($text) unless $token->[2];
            push(@text, $text);
        } elsif ($type =~ /^[SE]$/) {
            my $tag = $token->[1];
            if ($type eq "S") {
                if (defined(my $text = _textify($self, $token))) {
                    push(@text, $text);
                    next;
                }
            }
            if (!$HTML::Tagset::isPhraseMarkup{$tag}) {
                $self->unget_token($token);
                last;
            }
            push(@text, " ") if $tag eq "br";
        }
    }
    my $text = join("", @text);
    $text =~ s/^\s+//; $text =~ s/\s+$//; $text =~ s/\s+/ /g;
    $text;
}

1;

__END__


=head1 NAME

WWW::WTF::HTTPResource::Types::HTML - adapted HTML::TokeParser for WWW::WTF

=head1 DESCRIPTION

This is based on L<HTML::TokeParser>, all credit belongs to the original authors.

=head1 SEE ALSO

L<HTML::TokeParser>, L<HTML::PullParser>, L<HTML::Parser>

=cut
