#!/usr/bin/env nextflow

params.nr='s3://pipe.scratch.3/resources/nr/nr.gz'
nr_dataset = Channel.fromPath(params.nr)

fasta='s3://pipe.scratch.3/resources/CHK22_ref1_AA.fasta'
fasta_dataset=Channel.fromPath(params.fasta)


process formatdb {
	memory '96G'
	
	input:
	path nr from nr_dataset
	
	output:
	file "nr*" into maskedGenome
	
	"""
	gunzip $nr
  makeblastdb -dbtype prot -in nr
	"""
	
}
