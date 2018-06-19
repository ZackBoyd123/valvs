#!/usr/bin/python3
import sys
import random
import csv
import itertools
from collections import OrderedDict
import argparse
parser = argparse.ArgumentParser(description="A script to analyse what motifs a mutation is occuring after\n"+
            "To run this script the following are needed:\n\t--input\n\t--fasta\n\t--bases")
parser.add_argument("--input",help="Input converted diversitools entropy file. Use diversitools2vcf to get this file",
                    required=True)
parser.add_argument("--fasta",help="Input fasta file to analyse.",required=True)
parser.add_argument("--bases",help="How many bases to analyse in the for/rev direction",required=True)
parser.add_argument("--output",help="What to call the output file",required=True)
parser.add_argument("--rfriendly",help="Give me my output in a R format")
parser.add_argument("--combine", help="Combine for/rev mutations into one")
args = parser.parse_args()

#'''
#Input variables from command line
#'''
if args.rfriendly == None:
    rfriendly = False
else:
    rfriendly = True
if args.combine == None:
    combine = False
else:
    combine = True
mutation_file = args.input
fasta_file = args.fasta
bases_to_check = int(args.bases)
out_file = args.output

mut_position = []
alt_allele = []
dp_stats = []
# '''
# Pull out mutation position, alternate base and dp4 stats from input converted vcf file
# '''
with open(mutation_file) as mut_file:
    mut_data = csv.reader(mut_file,delimiter="\t")
    next(mut_data,None)
    for line in mut_data:
        mut_position.append(line[1])
        alt_allele.append(line[4])
        dp_stats.append(line[-1])
    mut_file.close()
# '''
# Function to chunk a list into a number of smaller lists
# '''
def chunks(l,n):
    for i in range(0, len(l), n):
        yield l[i:i + n]

# '''
# Function to split a string into smaller strings, in this case any split string
# which is less than three characters is ignored (not a trinucleotide).
# '''
def split(str, num, it):
    split_string = [ str[start:start+num] for start in range(0,len(str), it)]
    return_string = []
    for i in split_string:
        if not len(i) != num:
            return_string.append(i)

    return return_string

# '''
# Do some string and list manipulation.
# '''
mut_position = [i.replace(" ","") for i in mut_position]
mut_position = [int(i) for i in mut_position]
alt_allele = [i.replace(" ","") for i in alt_allele]
dp_stats = [i.replace(" ","") for i in dp_stats]
dp_stats = [i.rsplit(";")[-1] for i in dp_stats]
dp_stats = [i.rsplit(",")[2:4] for i in dp_stats]
dp_stats = [item for sublist in dp_stats for item in sublist]
dp_stats = chunks(dp_stats, 2)

# '''
# Pull out the sequence from the input file.
# '''
with open(fasta_file) as f_file:
    next(f_file,None)
    fasta_seq = f_file.readlines()

# '''
# Remove all the newline characters.
# '''
fasta_seq = "".join(fasta_seq).strip().rstrip()
fasta_seq = fasta_seq.replace("\n","")
fasta_seq = fasta_seq.upper()

# '''
# Write to a file the mutation, where it occurs and the bases before and after the mutation, set by the user.
# '''
sys.stdout = open(out_file+"_raw.txt","w")
total_mutations = 0
print("Position"+"\t"+"Reference"+"\t"+"Alternate"+"\t"+str(bases_to_check)+"_Before"+"\t"+str(bases_to_check)+"_After"
      +"\t"+"Alt_Forward"+"\t"+"Alt_Reverse")
for i,j,x in zip(mut_position,alt_allele,dp_stats):
    print(str(i)+"\t"+str(fasta_seq[i-1])+"\t"+str(j)+"\t"+str(fasta_seq[i-(bases_to_check+1):i-1])+"\t"
          +str(fasta_seq[i:i+bases_to_check])+"\t"+str(x[0])+"\t"+str(x[1]))
    total_mutations += int(x[0]) + int(x[1])

sys.stdout.close()
sys.stdout = sys.__stdout__
sys.stdout = open(out_file+"_calculations.txt","w")
forward_bases = []
forward_bases_occurence = []
reverse_bases = []
reverse_bases_occurence = []

# '''
# Open the previously created file and pull out the before and after bases
# Give forward and reverse a seperate variable.
# '''
with open(out_file+"_raw.txt") as f:
    data = csv.reader(f, delimiter="\t")
    next(data, None)
    for line in data:
        if int(line[-2:][0]) > 0:
            #print("For>Rev")
            forward_bases.append(line[3])
            forward_bases_occurence.append(line[5])
        if int(line[-2:][1]) > 0:
            #print("Rev>For")
            reverse_bases.append(line[4])
            reverse_bases_occurence.append(line[6])
    f.close()
#'''
#Get the reverse complement of the sublists. Merge into one big list of reverse complements then chunk
#into trinucleotides
#'''
reverse_bases = [i[::-1] for i in reverse_bases]
reverse_complement = []
complement = {"A": "T", "C": "G", "T" : "A", "G":"C", "N" : "N"}
for i in reverse_bases:
    for j in i:
        reverse_complement.append(complement[j])

reverse_complement = chunks(reverse_complement,bases_to_check)
reverse_complement = list(reverse_complement)
reverse_complement = ["".join(i) for i in reverse_complement]


# '''
# This function will make a dictionary of all 64 trinucleotides, and set each value to zero
# Then checks for occurence of trinucleotides in the given list and increments the corresponding dictionaries value
# by 1
# '''
def make_dictionaries(l,l2):
    a = "ACGTN"
    all_trinuc = ["".join(i) for i in itertools.product(a, repeat=bases_to_check)]
    trinuc_values = []
    for i in range(len(all_trinuc)):
        j = 0
        trinuc_values.append(j)

    trinuc_dict = dict(zip(all_trinuc,trinuc_values))
    for i, j in zip(l,l2):
        trinuc_dict[i] += int(j)
    return trinuc_dict


dataset= mutation_file.split(".")[0] 
# '''
# Order the dictionaries by value, from lowest to highest
# '''
forward_dict = make_dictionaries(forward_bases,forward_bases_occurence)
forward_dict = OrderedDict(sorted(forward_dict.items(), key=lambda x: x[1]))
reverse_dict = make_dictionaries(reverse_complement,reverse_bases_occurence)
reverse_dict = OrderedDict(sorted(reverse_dict.items(), key=lambda x: x[1]))
# # '''
# # Little print statement to tell the user what's going on
# # '''
forward_bases_occurence = [int(i) for i in forward_bases_occurence]
reverse_bases_occurence = [int(i) for i in reverse_bases_occurence]
total_mutations = (sum(forward_bases_occurence)) + sum(reverse_bases_occurence)
if not rfriendly:
    print("Total mutations:\t"+str(total_mutations) )
    print("You set the down/up stream bases to check at:\t"+str(bases_to_check)+"\t"+"Meaning we're looking at:\t"+
          str(int(bases_to_check - 2))+"\t"+"trinucleotides up/down stream")
    print("Here's what the string and mutation may look like.")
    rand = "ACGT"
    for en, i in enumerate(range(0,bases_to_check)):
        print(random.choice(rand),end="")
        if en > 1:
            print("|",end="")

    print("\tM")
if rfriendly:
    print("Motif\t"+"Percent\t"+"Raw\t"+"Direction\t"+"DataSet")
# #'''
# # Get the percentages of what trinucleotides the mutation occurs after / before and print to screen.
# #'''
if len(forward_bases) >= 1:
    gg_percent = 0
    aa_percent = 0
    cc_percent = 0
    tt_percent = 0
    if not rfriendly:
        print("\n"+"For all:"+"\t"+str(sum(forward_bases_occurence))+"\t"+"Mutations in the forward direction\n"+
              "Here's the percentage of those mutations which happen after the corresponding trinucleotide\n")
    for en, i in enumerate(reversed(forward_dict)):
        if combine:
            print(str(i) + "\t" + str(int(forward_dict[i]) / int(total_mutations) * 100) +
                  "\t" + str(forward_dict[i])+"\t"+"Combine\t"+str(dataset))
        else:
            print(str(i) + "\t" + str(int(forward_dict[i]) / int(sum(forward_bases_occurence)) * 100) +
                  "\t" + str(forward_dict[i])+"\t"+"Forward\t"+str(dataset))
        if i.endswith("GG"):
            gg_percent += int(forward_dict[i])/ int(sum(forward_bases_occurence)) * 100
        elif i.endswith("AA"):
            aa_percent += int(forward_dict[i])/ int(sum(forward_bases_occurence)) * 100
        elif i.endswith("CC"):
            cc_percent += int(forward_dict[i])/ int(sum(forward_bases_occurence)) * 100
        elif i.endswith("TT"):
            tt_percent += int(forward_dict[i])/ int(sum(forward_bases_occurence)) * 100
    if not rfriendly:
        print("\n"+"Mutations which came directly after a trinucleotide ending in GG:\t"+str(gg_percent))
        print("Mutations which came directly after a trinucleotide ending in AA:\t"+str(aa_percent))
        print("Mutations which came directly after a trinucleotide ending in CC:\t"+str(cc_percent))
        print("Mutations which came directly after a trinucleotide ending in TT:\t"+str(tt_percent))

else:
    print("\nNo forward mutations")
if len(reverse_bases) >= 1:
    gg_percent_rev = 0
    aa_percent_rev = 0
    cc_percent_rev = 0
    tt_percent_rev = 0
    if not rfriendly:
        print("\n\nFor all:"+"\t"+str(sum(reverse_bases_occurence))+"\t"+"Mutations in the reverse direction\n")
    for en, i in enumerate(reversed(reverse_dict)):
        if combine:
            print(str(i)+"\t"+str(int(reverse_dict[i])/ int(total_mutations) *100) +"\t"
                  + str(reverse_dict[i])+"\t"+"Combine\t"+str(dataset))
        else:
            print(str(i)+"\t"+str(int(reverse_dict[i])/ int(sum(reverse_bases_occurence)) *100) +"\t"
                  + str(reverse_dict[i])+"\t"+"Reverse\t"+str(dataset))
        if i.endswith("GG"):
            gg_percent_rev += int(reverse_dict[i]) / int(sum(reverse_bases_occurence)) * 100
        elif i.endswith("AA"):
            aa_percent_rev += int(reverse_dict[i]) / int(sum(reverse_bases_occurence)) * 100
        elif i.endswith("CC"):
            cc_percent_rev += int(reverse_dict[i]) / int(sum(reverse_bases_occurence)) * 100
        elif i.endswith("TT"):
            tt_percent_rev += int(reverse_dict[i]) / int(sum(reverse_bases_occurence)) * 100
    if not rfriendly:
        print("\n" + "Mutations which came directly after a trinucleotide ending in GG:\t" + str(gg_percent_rev))
        print("Mutations which came directly after a trinucleotide ending in AA:\t" + str(aa_percent_rev))
        print("Mutations which came directly after a trinucleotide ending in CC:\t" + str(cc_percent_rev))
        print("Mutations which came directly after a trinucleotide ending in TT:\t" + str(tt_percent_rev))
else:
    print("\nNo reverse mutations")
