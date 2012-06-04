#!/usr/bin/perl

use strict;
use warnings;

use MendeleySQLite;
use Data::Dumper;
use Getopt::Long;
use HTML::TagCloud;

my $rh_params = { };

GetOptions(
    $rh_params,
    'help',
    'dbfile:s',
    'mode:s' );

if ( $rh_params->{'help'} ){
    help_and_exit();
}

unless ( defined $rh_params->{'dbfile'} ){
    help_and_exit();
}

my $rh_modes = {
    'keywords' => 1,
    'tags'     => 1,
};

unless ( defined $rh_params->{mode} && exists $rh_modes->{ $rh_params->{mode} } ) {
    help_and_exit();
}

my $M = MendeleySQLite->new( $rh_params );

my $rh_all = { };

if ( $rh_params->{mode} eq 'keywords' ) {
    $rh_all = $M->get_all_keywords();
} else {
    $rh_all = $M->get_all_tags();
}

my $cloud = HTML::TagCloud->new;

foreach my $key ( keys %$rh_all ) {
    my $count = $rh_all->{$key};
    $cloud->add_static( $key, $count );
}

print $cloud->html_and_css(50);

#################################################################################
#################################################################################


sub help_and_exit {
    
    print <<"END"
    
    $0: Create a tagcloud from your Mendeley keywords or tags and print the HTML/CSS to STDOUT.
        
    --dbfile : path to SQLite file
    --mode   : 'keywords' for keywords and 'tags' for tags 
    --help   : print this help message and exit
    
END
;

    exit;
    
}