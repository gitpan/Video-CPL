package Video::CPL::Annotation;

use warnings;
use strict;
use Carp;
use Data::Dumper;
use XML::Writer;

use Video::CPL::Story;
use Video::CPL::Target;
use Video::CPL::TargetList;

=head1 NAME

Video::CPL::Annotation - Video::CPL::Annotation object.

=head1 VERSION

Version 0.09

=cut

our $VERSION = '0.09';

=head1 SYNOPSIS

    Video::CPL::Annotate exists to create and manipulate Annotations. CPL.pm is moving towards including more 
and more helper functions; eventually this routine should be most useful for accessor functions, to modify
or examine attributes. 

    use Video::CPL::Annotation;
    my $foo = Video::CPL::Annotation->new(name=>"alpha-tech",clickBehavior=>"goto",x=>772,y=>66,
         story=>new Video::CPL::Story(pic=>"foo.png"));

=head1 METHODS

=cut

our @FIELDS = qw(name clickBehavior x y skipOnReturn showIcon story ajs alpha targetList parent);
our @SIMPLEFIELDS = qw(name clickBehavior x y skipOnReturn showIcon ajs alpha);
our %COMPLEX = (story=>1,targetList=>1,parent=>1);

#accessors: creating these dynamically in BEGIN has complications. 
sub name { my $obj = shift; $obj->{name} = shift if @_; return $obj->{name}; }
sub clickBehavior { my $obj = shift; $obj->{clickBehavior} = shift if @_; return $obj->{clickBehavior}; }
sub x { my $obj = shift; $obj->{x} = shift if @_; return $obj->{x}; }
sub y { my $obj = shift; $obj->{y} = shift if @_; return $obj->{y}; }
sub skipOnReturn { my $obj = shift; $obj->{skipOnReturn} = shift if @_; return $obj->{skipOnReturn}; }
sub showIcon { my $obj = shift; $obj->{showIcon} = shift if @_; return $obj->{showIcon}; }
sub ajs { my $obj = shift; $obj->{ajs} = shift if @_; return $obj->{ajs}; }
sub story { my $obj = shift; $obj->{story} = shift if @_; return $obj->{story}; }
    #proposed
    #picLoc picOverLoc ballonText forever
    #if present will create and add story
sub picLoc { my $obj = shift;
    if (@_){
       if ($obj->story()){
           $obj->story()->picLoc(@_);
       } else {
           $obj->{story} = new Video::CPL::Story(picLoc=>@_);
       }
    } else {
        return undef if !$obj->story();
    }
    return $obj->story()->picLoc();
}
sub alpha { my $obj = shift; $obj->{alpha} = shift if @_; return $obj->{alpha}; }
sub targetList { my $obj = shift; $obj->{targetList} = shift if @_; return $obj->{targetList}; }
#proposed: add 
   #target [accept array or scalar. Strings or cuePt. return array if wantarray else single target if only one else croak.]
   #backgroundPicLoc
   #operation 
   #headerText
sub parent { my $obj = shift; $obj->{parent} = shift if @_; return $obj->{parent}; }

=head2 new(name=>"foo",click=>"goto",x=>23,y=>40)

    Creates a new Annotation object.

=cut

sub new {
    my $pkg = shift;
    my %p = @_;
    my $ret = {};
    bless $ret,$pkg;

    confess("new Annotation without parent\n") if !defined $p{parent};
    $p{name} = $p{parent}->newname("anno") if !defined $p{name};
    my %s;
    foreach my $s (@Video::CPL::Story::FIELDS){
        if (defined($p{$s})){
	    $s{$s} = $p{$s};
	    delete $p{$s};
	}
    }
    $ret->{story} = new Video::CPL::Story(%s) if %s;
    if (defined($p{target})){
        $ret->{targetList} = new Video::CPL::TargetList(target=>[new Video::CPL::Target(cuePointRef=>$p{target})]);
	delete $p{target};
    }

    foreach my $x (@FIELDS){
	$ret->{$x} = $p{$x} if defined $p{$x};
    }
    foreach my $x (keys %p){
        confess("Parameter ('$x') given to Video::CPL::Annotation::new, but not understood\n") if !defined $ret->{$x};
    }

    return $ret;
}


=head2 adjust(parm1=>val,parm2=>val,...)

    Change arbitrary fields within an Annotation point.

=cut

sub adjust {
    my $obj = shift;
    my %parms = @_;
    foreach my $x (qw(name clickBehavior skipOnReturn showIcon alpha relative skip x y modal story )){
         $obj->{$x} = $parms{$x} if defined($parms{$x});
    }

    return $obj;
}

=head2 fromxml()

=cut

sub fromxml{
    my $parent = shift;
    my $s = shift;
    my %s = %{$s};
    my %p = (parent=>$parent);
    foreach my $k (@SIMPLEFIELDS){
        $p{$k} = $s{$k} if defined($s{$k});
    }
    $p{story} = Video::CPL::Story::fromxml($s{story}[0]) if defined($s{story}[0]);
    $p{targetList} = Video::CPL::TargetList::fromxml($s{targetList}[0]) if defined($s{targetList}[0]);
    return new Video::CPL::Annotation(%p);
}

=head2 xml()

    Return the text form of the Annotation. Usually called by Video::CPL::xml().

=cut 

sub xmlo {
    #given parent, add stuff to it and return.
    my $obj = shift;
    my $xo = shift;
    my %p;
    foreach my $x (@SIMPLEFIELDS){
	$p{$x} = $obj->{$x} if defined($obj->{$x});
    }
    $xo->startTag("annotation",%p);
    $obj->{story}->xmlo($xo) if defined $obj->{story};
    $obj->{targetList}->xmlo($xo) if defined $obj->{targetList};
    $xo->endTag("annotation");
}

sub xml {
    my $obj = shift;
    my $a = "";
    my $xo = new XML::Writer(OUTPUT=>\$a);
    $obj->xmlo($xo);
    $xo->end();
    return $a;
}

=head2 reffromobj($cplobj)

=cut

sub reffromobj {
    my $obj = shift;
    my $cpl = shift;
    confess("Video::CPL::Annotation::reffromobj but no parent\n") if !defined($obj->{parent});
    return $obj->{name} if $obj->parent() == $cpl;
    my $ctvfile = $obj->parent()->{ctvfilename};
    return "/$ctvfile\#$obj->{name}";
    #TODO: support for CPL objects with a different domain, think about dynamic
}

=head2 printref()

    Return a cuePointRef to this Annotation.

=cut

sub printref {
    my $obj = shift;
    my $name = $obj->{name};
    return "<target cuePointRef=\"$name\"/>\n";
}

=head1 AUTHOR

Carl Rosenberg, C<< <perl at coincident.tv> >>

=head1 BUGS

Please report any bugs or feature requests to Coincident TV.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Video::CPL::Annotation


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

1; # End of Video::CPL::Annotation
