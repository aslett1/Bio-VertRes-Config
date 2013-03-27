package Bio::VertRes::Config::Pipelines::AnnotateAssembly;

# ABSTRACT: A class for generating the AnnotateAssembly pipeline config file which annotates an assembly

=head1 SYNOPSIS

A class for generating the AnnotateAssembly pipeline config file
   use Bio::VertRes::Config::Pipelines::AnnotateAssembly;
   
   my $pipeline = Bio::VertRes::Config::Pipelines::AnnotateAssembly->new(database => 'abc');
   $pipeline->to_hash();

=cut

use Moose;
use Bio::VertRes::Config::Pipelines::Common;
extends 'Bio::VertRes::Config::Pipelines::Common';

has 'pipeline_short_name'  => ( is => 'ro', isa => 'Str', default => 'annotate_assembly' );
has 'module'               => ( is => 'ro', isa => 'Str', default => 'VertRes::Pipelines::AnnotateAssembly' );
has 'prefix'               => ( is => 'ro', isa => 'Bio::VertRes::Config::Prefix', default => '_annotate_' );
has 'toplevel_action'      => ( is => 'ro', isa => 'Str', default => '__VRTrack_AnnotateAssembly__' );

has '_max_failures'        => ( is => 'ro', isa => 'Int', default => 3 );
has '_max_lanes_to_search' => ( is => 'ro', isa => 'Int', default => 1000 );
has '_limit'               => ( is => 'ro', isa => 'Int', default => 100 );
has '_tmp_directory'       => ( is => 'ro', isa => 'Str', default => '/lustre/scratch108/pathogen/pathpipe/tmp' );
has '_assembler'           => ( is => 'ro', isa => 'Str', default => 'velvet' );
has '_annotation_tool'     => ( is => 'ro', isa => 'Str', default => 'prokka' );
has '_dbdir'               => ( is => 'ro', isa => 'Str', default => '/lustre/scratch108/pathogen/pathpipe/prokka' );

override 'to_hash' => sub {
    my ($self) = @_;
    my $output_hash = super();
    $output_hash->{limit}                   = $self->_limit;
    $output_hash->{max_lanes_to_search}     = $self->_max_lanes_to_search;
    $output_hash->{max_failures}            = $self->_max_failures;
    $output_hash->{vrtrack_processed_flags} = { assembled => 1, annotated => 0 };

    $output_hash->{data}{tmp_directory}     = $self->_tmp_directory;
    $output_hash->{data}{assembler}         = $self->_assembler;
    $output_hash->{data}{annotation_tool}   = $self->_annotation_tool;
    $output_hash->{data}{dbdir}             = $self->_dbdir;

    return $output_hash;
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;
