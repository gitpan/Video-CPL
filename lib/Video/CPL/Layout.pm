package Video::CPL::Layout;

use warnings;
use strict;
use Carp;
use XML::Writer;
use Data::Dumper;

=head1 NAME

Video::CPL::Layout - Manage layouts.

=head1 VERSION

Version 0.09

=cut

our $VERSION = '0.09';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Video::CPL::Layout;


=head1 SUBROUTINES/METHODS

=cut

our @FIELDS = qw(videoHeight videoVCenter videoTop videoBottom videoWidth videoHCenter videoLeft videoRight webHeight webVCenter webTop webBottom webWidth webHCenter webLeft webRight name);

sub videoHeight { my $obj = shift; $obj->{videoHeight} = shift if @_; return $obj->{videoHeight};};
sub videoVCenter { my $obj = shift; $obj->{videoVCenter} = shift if @_; return $obj->{videoVCenter};};
sub videoTop { my $obj = shift; $obj->{videoTop} = shift if @_; return $obj->{videoTop};};
sub videoBottom { my $obj = shift; $obj->{videoBottom} = shift if @_; return $obj->{videoBottom};};
sub videoWidth { my $obj = shift; $obj->{videoWidth} = shift if @_; return $obj->{videoWidth};};
sub videoHCenter { my $obj = shift; $obj->{videoHCenter} = shift if @_; return $obj->{videoHCenter};};
sub videoLeft { my $obj = shift; $obj->{videoLeft} = shift if @_; return $obj->{videoLeft};};
sub videoRight { my $obj = shift; $obj->{videoRight} = shift if @_; return $obj->{videoRight};};
sub webHeight { my $obj = shift; $obj->{webHeight} = shift if @_; return $obj->{webHeight};};
sub webVCenter { my $obj = shift; $obj->{webVCenter} = shift if @_; return $obj->{webVCenter};};
sub webTop { my $obj = shift; $obj->{webTop} = shift if @_; return $obj->{webTop};};
sub webBottom { my $obj = shift; $obj->{webBottom} = shift if @_; return $obj->{webBottom};};
sub webWidth { my $obj = shift; $obj->{webWidth} = shift if @_; return $obj->{webWidth};};
sub webHCenter { my $obj = shift; $obj->{webHCenter} = shift if @_; return $obj->{webHCenter};};
sub webLeft { my $obj = shift; $obj->{webLeft} = shift if @_; return $obj->{webLeft};};
sub webRight { my $obj = shift; $obj->{webRight} = shift if @_; return $obj->{webRight};};
sub name { my $obj = shift; $obj->{name} = shift if @_; return $obj->{name};};

=head2 new()

    Create a new Layout object.

=cut 

sub new {
    my $pkg = shift;
    my %parms = @_;
    my $ret = {};
    bless $ret,$pkg;

    foreach my $x (@FIELDS){
	$ret->{$x} = $parms{$x} if defined $parms{$x};
    }
    foreach my $x (keys %parms){
        confess("Parameter ('$x') given to Video::CPL::Layout::new, but not understood\n") if !defined $ret->{$x};
    }

    return $ret;
}

=head2 xmlo
  
    Given an XML::Writer object, add the xml information for this Layout.

=cut

sub xmlo {
    my $obj = shift;
    my $xo = shift;
    my %p;
    foreach my $x (@FIELDS){
        $p{$x} = $obj->{$x} if defined $obj->{$x};
    }
    $xo->emptyTag("layout",%p);
}

=head2 xml()

    Return the xml format of a Layout object.

=cut

sub xml {
    my $obj = shift;
    my $a;
    my $xo = new XML::Writer(OUTPUT=>\$a);
    $obj->xmlo($xo);
    $xo->end();
    return $a;
}

sub fromxml {
    my $s = shift;
    my %s = %{$s};
    my %p;
    foreach my $q (@FIELDS){
        $p{$q} = $s{$q} if defined($s{$q});
    }
    return new Video::CPL::Layout(%p);
}

=head1 AUTHOR

Carl Rosenberg, C<< <perl at coincident.tv> >>

=head1 BUGS

Please report any bugs or feature requests to Coincident TV.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Video::CPL::Layout

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Coincident TV

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
=cut

1; # End of Video::CPL::Layout
