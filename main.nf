#!/usr/bin/env nextflow

params.nr='s3://pipe.scratch.3/resources/nr/nr.gz'
nr_dataset = Channel.fromPath(params.nr)

params.fasta='s3://pipe.scratch.3/resources/CHK22_ref1_AA.fasta'
fasta_dataset=Channel.fromPath(params.fasta)


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

/*
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
	path "$fastafile.*" into splits
	
	
	"""
	gt splitfasta -numfiles 100 $fastafile
	"""
	
}


formatteddb.into { formatteddb_blast; formatteddb_header }

chunks=98


process runfasta {
	memory '2G'
	
	input:
	each x from 1..chunks
	path fastas from splits.collect()
	path db from formatteddb_blast.collect()
	
	output:
	file "CHK22_ref1_AA.fasta.${x}.blastout.txt" into blastouts
	
	
	"""
	blastp -db nr -query "CHK22_ref1_AA.fasta.${x}" -outfmt 6 -max_target_seqs 1 -out  "CHK22_ref1_AA.fasta.${x}.blastout.txt"
	"""

}



process pullheaders {
	memory '2G'
	
	input:
	path db from formatteddb_header.collect()
	
	output:
	file "functionHeader.txt" into headerouts
	
	
	"""
	grep ">" $db > functionHeader.txt
	"""

}




