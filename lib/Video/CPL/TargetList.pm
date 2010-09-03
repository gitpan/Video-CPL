package Video::CPL::TargetList;

use warnings;
use strict;
use Video::CPL::Target;
use XML::Writer;
use Carp;
use Data::Dumper;


=head1 NAME

Video::CPL::TargetList - The great new Video::CPL::TargetList!

=head1 VERSION

Version 0.08

=cut

our $VERSION = '0.08';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Video::CPL::TargetList;

    my $foo = Video::CPL::TargetList->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=cut

our @FIELDS = qw(backgroundPicLoc headerText operation target);

#dynamic INIT-block creation of these routines has too many problems. spell it out.
sub backgroundPicLoc { my $obj = shift; $obj->{backgroundPicLoc} = shift if @_; return $obj->{backgroundPicLoc};};
sub headerText { my $obj = shift; $obj->{headerText} = shift if @_; return $obj->{headerText};};
sub operation { my $obj = shift; $obj->{operation} = shift if @_; return $obj->{operation};};
sub target { my $obj = shift; $obj->{target} = shift if @_; return $obj->{target};};

=head2 new()

    Create a new TargetList object.

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
        confess("Parameter ('$x') given to Video::CPL::TargetList::new, but not understood\n") if !defined $ret->{$x};
    }

    return $ret;
}

=head2 xmlo
  
    Given an XML::Writer object, add the xml information for this TargetList.

=cut

sub xmlo {
    my $obj = shift;
    my $xo = shift;
    my %p;
    foreach my $x (@FIELDS){
        next if $x eq "target";
        $p{$x} = $obj->{$x} if defined $obj->{$x};
    }
    $xo->startTag("targetList",%p);
    foreach my $c (@{$obj->{target}}){ #if we are a targetList we must have target
        #print "Video::CPL::TargetList::xmlo in loop\n".Dumper($xo);
	$c->xmlo($xo);
    }
    $xo->endTag("targetList");
}

=head2 xml()

    Return the xml format of a TargetList object.

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
    my %parms;
    foreach my $q (@FIELDS){
        next if $q eq "target";
        $parms{$q} = $s{$q} if defined($s{$q});
    }
    #process targets
    my @t;
    foreach my $x (@{$s{target}}){
	push @t,Video::CPL::Target::fromxml($x);
    }
    $parms{target} = \@t;
    return new Video::CPL::TargetList(%parms);
}

=head1 AUTHOR

Carl Rosenberg, C<< <perl at coincident.tv> >>

=head1 BUGS

Please report any bugs or feature requests to Coincident TV.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.


=head1 LICENSE AND COPYRIGHT

Copyright 2010 Coincident TV, Inc.

=cut

1;
