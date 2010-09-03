package Video::CPL::Target;

use warnings;
use strict;
use Carp;
use Data::Dumper;
use XML::Writer;

=head1 NAME

Video::CPL::Target - The great new Video::CPL::Target!

=head1 VERSION

Version 0.09

=cut

our $VERSION = '0.09';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Video::CPL::Target;

    my $foo = Video::CPL::Target->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=cut

our @FIELDS = qw(cuePointRef association modal);

#cuePointRef : new model is that this is a string

#dynamic INIT-block creation of these routines has too many problems. spell it out.
sub cuePointRef { my $obj = shift; $obj->{cuePointRef} = shift if @_; return $obj->{cuePointRef};};
sub association { my $obj = shift; $obj->{association} = shift if @_; return $obj->{association};};
sub modal { my $obj = shift; $obj->{modal} = shift if @_; return $obj->{modal};};

=head2 new()

    Create a new Target object.

=cut 

sub new {
    my $pkg = shift;
    my %p = @_;
    my $ret = {};
    bless $ret,$pkg;
    foreach my $x (@FIELDS){
        $ret->{$x} = $p{$x} if defined $p{$x};
    }
    foreach my $x (keys %p){
        confess("Parameter ('$x') given to Video::CPL::Target::new, but not understood\n") if !defined $ret->{$x};
    }
    return $ret;
}

=head2 xmlo
  
    Given an XML::Writer object, add the xml information for this Target.

=cut

sub xmlo {
    my $obj = shift;
    my $xo = shift;
    my %p;
    foreach my $x (@FIELDS){
        $p{$x} = $obj->{$x} if defined $obj->{$x};
    }
    $xo->emptyTag("target",%p);
}

=head2 xml()

    Return the xml format of a Target object.

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
        $p{$q} = $s{$q} if defined $s{$q};
    }
    return new Video::CPL::Target(%p);
}

=head1 AUTHOR

Carl Rosenberg, C<< <perl at coincident.tv> >>

=head1 BUGS

Please report any bugs or feature requests to Coincident TV.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Video::CPL::Target

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

1;
