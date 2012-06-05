#!/usr/bin/perl

use strict;
use warnings;

package MendeleySQLite;

use Data::Dumper;
use DBI;
use SQL::Abstract;

# ABSTRACT: A collection of tools for working with Mendeley Desktop's SQLite backend.

=head2 new

    Returns a new instance of the class.

=cut

sub new {
    my $class     = shift;
    my $rh_params = shift;
    my $self      = { };
    
    unless ( defined $rh_params->{dbfile} && -e $rh_params->{dbfile} ){
        die "Specify the path to the SQLite database using the dbfile parameter."
    }
    
    $self->{dbh} = 
        DBI->connect("dbi:SQLite:dbname=$rh_params->{dbfile}","","");
        
    unless ( $self->{dbh} ) {
        die "Could not connect to $rh_params->{dbfile}."
    }
    
    $self->{sql} = SQL::Abstract->new();
    
    return bless $self, $class;
}

=head2 get_all_keywords

    Get all keywords associated with documents from your library. Returns a reference to a hash
    with the keywords and their frequency.
    
    my $rh_keywords = $M->get_all_keywords();    

=cut

sub get_all_keywords {
    my $self = shift;
    
    my $sql_all_keywords = 
        'SELECT keyword,COUNT(*) AS n from DocumentKeywords GROUP BY keyword';
    
    my $sth = $self->_execute_sql( $sql_all_keywords );
    
    my $ra_all = $sth->fetchall_arrayref();
    
    my $rh_out = { };
    
    foreach my $ra ( @$ra_all ) {
        $rh_out->{$ra->[0]} = $ra->[1];
    }
    
    return $rh_out;    
    
}

=head2 get_all_tags

    Get all tags associated with documents from your library. Returns a reference to a hash
    with the tags and their frequency.
    
    my $rh_tags = $M->get_all_tags();    

=cut

sub get_all_tags {
    my $self = shift;
    
    my $sql_all_tags = 
        'SELECT tag,COUNT(*) AS n from DocumentTags GROUP BY tag';
    
    my $sth = $self->_execute_sql( $sql_all_tags );
    
    my $ra_all = $sth->fetchall_arrayref();
    
    my $rh_out = { };
    
    foreach my $ra ( @$ra_all ) {
        $rh_out->{$ra->[0]} = $ra->[1];
    }
    
    return $rh_out;    
    
}

=head2 get_all_tags_for_document

    Get all tags associated with a document in your library. Returns a reference to an array.
    This method returns undef on error.
    
    my $ra_tags = $M->get_all_tags_for_document( $documentid );

=cut

sub get_all_tags_for_document {
    my $self = shift;
    my $document_id = shift;
    
    return undef if ( ! defined $document_id );
    
    my $ra_output = [ ];
        
    my ( $sql, $ra_bind ) = 
        $self->_create_sql( 'DocumentTags', [ 'tag' ], { documentId => $document_id } );
    
    my $sth = $self->_execute_sql( $sql, $ra_bind );
  
    my $ra_all = $sth->fetchall_arrayref();
    
    unless ( scalar(@$ra_all) ) {
        return $ra_output;
    }    
    
    foreach my $ra ( @$ra_all ) {
        push( @$ra_output, $ra->[0] );
    }

    return $ra_output;
}

=head2 get_all_keywords_for_document

    Get all keywords associated with a document in your library. Returns a reference to an array.
    This method returns undef on error.
    
    my $ra_keywords = $M->get_all_keywords_for_document( $documentid );

=cut

sub get_all_keywords_for_document {
    my $self        = shift;
    my $document_id = shift;
    
    return undef if ( ! defined $document_id );
    
    my $ra_output = [ ];
        
    my ( $sql, $ra_bind ) = 
        $self->_create_sql( 'DocumentKeywords', [ 'keyword' ], { documentId => $document_id } );
    
    my $sth = $self->_execute_sql( $sql, $ra_bind );
  
    my $ra_all = $sth->fetchall_arrayref();
    
    unless ( scalar(@$ra_all) ) {
        return $ra_output;
    }    
    
    foreach my $ra ( @$ra_all ) {
        push( @$ra_output, $ra->[0] );
    }

    return $ra_output;
}

sub _create_sql {
    my $self      = shift;
    my $table     = shift;
    my $ra_fields = shift;
    my $rh_params = shift;
    
    my ( $stmt, @bind ) =
        $self->{sql}->select( $table, $ra_fields, $rh_params );
        
    return ( $stmt, \@bind );
}


sub _execute_sql {
    my $self = shift;
    my $sql  = shift;
    my $ra_params = shift || [ ];
        
    my $sth = 
        $self->{dbh}->prepare( $sql );
        
    $sth->execute( @$ra_params );
    
    return $sth;    
    
}






1;