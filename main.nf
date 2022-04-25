#!/usr/bin/env nextflow

params.nr='s3://pipe.scratch.3/resources/nr/nr.gz'
nr_dataset = Channel.fromPath(params.nr)

params.fasta='s3://pipe.scratch.3/resources/CHK22_ref1_AA.fasta'
fasta_dataset=Channel.fromPath(params.fasta)

/*
process formatdb {
	
	input:
	path nr from nr_dataset
	
	output:
	file "nr*" into formatteddb
	
	"""
	gunzip $nr
  	makeblastdb -dbtype prot -in nr
	"""
	
}

process runblast {
	memory '2G'
	
	input:
	path db from formatteddb.collect()
	
	output:
	file "blastfiles.txt" into blastoutput
	
	
	"""
	ls nr* > blastfiles.txt
	"""
	
}
*/


process splitfasta {
	memory '2G'
	
	input:
	path fastafile from fasta_dataset
	
	output:
	file "$fastafile.*" into mergeGtHints
	
	
	"""
	gt splitfasta -numfiles 100 $fastafile
	"""
	
}











