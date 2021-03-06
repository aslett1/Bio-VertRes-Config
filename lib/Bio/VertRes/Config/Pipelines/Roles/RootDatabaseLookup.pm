package Bio::VertRes::Config::Pipelines::Roles::RootDatabaseLookup;

# ABSTRACT: Moose Role for translating non standard database names to their area

=head1 SYNOPSIS

Moose Role for translating non standard database names to their area

   with 'Bio::VertRes::Config::Pipelines::Roles::RootDatabaseLookup';

=method root_database_name_lookup

Translate root database name taking non standards into account.

=cut

use Moose::Role;

has 'root_database_name'     => ( is => 'ro', isa => 'Str',     lazy => 1, builder => '_build_root_database_name' );
has 'non_standard_databases' => ( is => 'ro', isa => 'HashRef', lazy => 1, builder => '_build_non_standard_databases' );

sub _build_root_database_name {
    my ($self) = @_;
    return $self->root_database_name_lookup( $self->database );
}

sub _build_non_standard_databases {
    my ($self) = @_;
    my %non_standard_databases = (
        'pathogen_virus_track'    => 'viruses',
        'pathogen_prok_track'     => 'prokaryotes',
        'pathogen_euk_track'      => 'eukaryotes',
        'pathogen_helminth_track' => 'helminths',
        'pathogen_rnd_track'      => 'rnd'
    );
    return \%non_standard_databases;
}

sub root_database_name_lookup {
    my ( $self, $database_name ) = @_;

    if ( $self->non_standard_databases->{$database_name} ) {
        return $self->non_standard_databases->{$database_name};
    }
    return $database_name;
}

no Moose;
1;

