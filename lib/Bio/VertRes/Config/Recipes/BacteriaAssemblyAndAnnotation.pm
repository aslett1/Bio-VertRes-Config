package Bio::VertRes::Config::Recipes::BacteriaAssemblyAndAnnotation;
# ABSTRACT: Create the assembly and anntation files only, so no reference required, but for it to run you need to have done QC first

=head1 SYNOPSIS

Register and QC a study
   use Bio::VertRes::Config::Recipes::BacteriaAssemblyAndAnnotation;

   my $obj = Bio::VertRes::Config::Recipes::BacteriaAssemblyAndAnnotation->new(
     database => 'abc',
     limits => {project => ['Study ABC']}
     );
   $obj->create;

=cut

use Moose;
extends 'Bio::VertRes::Config::Recipes::Common';
with 'Bio::VertRes::Config::Recipes::Roles::BacteriaRegisterStudy';

has 'assembler'            => ( is => 'ro', isa => 'Str',  default => 'velvet' );
has '_error_correct'       => ( is => 'ro', isa => 'Bool', default => 0 );
has '_remove_primers'      => ( is => 'ro', isa => 'Bool', default => 0 );
has '_pipeline_version'    => ( is => 'ro', isa => 'Str' );
has '_normalise'           => ( is => 'ro', isa => 'Bool', default => 0 );
has '_kingdom'             => ( is => 'ro', isa => 'Str',  default => "Bacteria" );
has '_vrtrack_processed_flags'    => ( is => 'ro', isa => 'HashRef', default => sub {{ assembled => 0, stored => 1, rna_seq_expression => 0 }} );
has 'iva_qc'			   => ( is => 'ro', isa => 'Bool', default => 0 );
has 'kraken_db'		   => ( is => 'ro', isa => 'Str',  default => "/lustre/scratch108/pathogen/pathpipe/kraken/assemblyqc_fluhiv_20150728" );


override '_pipeline_configs' => sub {
    my ($self) = @_;
    my @pipeline_configs;
    if($self->assembler eq 'spades')
    {
        $self->add_bacteria_spades_assembly_config(\@pipeline_configs);
    }
    else
    {
        $self->add_bacteria_velvet_assembly_config(\@pipeline_configs);
    }
    $self->add_bacteria_annotate_config(\@pipeline_configs);

    return \@pipeline_configs;
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;

