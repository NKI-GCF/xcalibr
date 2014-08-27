use strict;
use warnings;

package SequenceSet;

use Carp;

sub new {
	my $class = shift;
	my $len = shift;
	my $self = {};
	bless $self, $class;

	$self->{seqs} = {};
	$self->{len} = $len if defined $len;

	return $self;
}

sub all_seqs {
	my $self = shift;
	return keys %{$self->seqs};
}

sub all_names {
	my $self = shift;
	return map { join(":", @$_) } values(%{$self->{seqs}});
}

sub read_from_fasta {
	my $self = shift;
	my $file = shift;

	croak "File not found $file" unless -e $file;	

	require Bio::SeqIO;

	my $in  = Bio::SeqIO->new(-file => $file, -format => 'Fasta');
	while (my $seq = $in->next_seq() ) {
		my $s = $seq->seq;
		$s = substr $s,0,$self->{len} if exists $self->{len};
		push @{$self->{seqs}->{$s}}, $seq->id;	
	}
}

sub match {
	my $self = shift;
	my $seq = shift;
	return undef unless exists $self->{seqs}->{$seq};
	return join(":", @{$self->{seqs}->{$seq}});
}

1;

