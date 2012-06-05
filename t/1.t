#!/usr/bin/perl 

use strict;
use warnings;

use Test::More;
use Test::Deep;
use Data::Dumper;
use MendeleySQLite;

my $test_data = './t/test-data.db';

if ( ! -e $test_data ) {
    plan 'skip_all' => 'Test data file could not be read';
    done_testing();
}

my $M = MendeleySQLite->new( { 'dbfile' => $test_data } );

isa_ok( $M, 'MendeleySQLite' );

{

    ##
    ## get_all_keywords

    my $rh_keywords = $M->get_all_keywords();
    
    my $rh_expected = {
              'oral adverse effects' => '1',
              'randomized controlled trials topic' => '2',
              'randomized controlled trials topic standards' => '1',
              'observational' => '1',
              'factor v genetics' => '1',
              'biomedical research' => '1',
              'oral' => '1',
              'evaluation studies topic' => '1',
              'biomedical research methods' => '1',
              'how-to' => '1',
              'venous thromboembolism genetics' => '1',
              'bias' => '2',
              'follow up studies' => '1',
              'venous thromboembolism' => '1',
              'factor v' => '1',
              'female' => '1',
              'pharmaceutical preparations adverse effects' => '1',
              'Mendeley' => '1',
              'risk' => '1',
              'confounding factors (epidemiology)' => '1',
              'case control studies' => '1',
              'user manual' => '1',
              'retrospective studies' => '1',
              'interventional' => '1',
              'error' => '1',
              'pharmaceutical preparations' => '1',
              'biomedical research standards' => '1',
              'contraceptives' => '1',
              'humans' => '2',
              'research design' => '1',
              'prospective studies' => '1',
              'observation' => '1',
              'random allocation' => '1',
              'RCT' => '1',
              'bias (epidemiology)' => '1'
            };
    
    cmp_deeply(
        $rh_expected,
        $rh_keywords 
    );
        
}

{
    
    ##
    ## get_all_tags()
    
    my $rh_tags = $M->get_all_tags();
    
    my $rh_expected = {
              'observational' => '2',
              'confounding' => '2',
              'RCT' => '3',
              'interventional' => '1',
              'error' => '1',
              'bias' => '3'
            };
    
    cmp_deeply(
            $rh_expected,
            $rh_tags
        );

}

{
    
    ##
    ## get_all_tags_for_document()
    
    my $ra_tags = $M->get_all_tags_for_document('2');
    
    my $ra_expected = ['bias', 'error' ];
    
    cmp_deeply(
        $ra_expected,
        $ra_tags );
    
}

{
    
    ##
    ## get_all_keywords_for_document()

    my $ra_keywords = $M->get_all_keywords_for_document('2');

    my $ra_expected = [ 'bias', 'error' ];
    
    cmp_deeply(
        $ra_keywords,
        $ra_expected );
    
}


























done_testing();