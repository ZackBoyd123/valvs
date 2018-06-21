#!/usr/bin/python3
import sys
import csv
import copy
import argparse
import math
from scipy import stats
parser = argparse.ArgumentParser(description="I need -1, -2 and --sample")
parser.add_argument("--first",help="First input file",required=True)
parser.add_argument("--second",help= "Second input file", required=True)
parser.add_argument("--sample",help="Unique sample name i.e Tag1",required=True)
args = parser.parse_args()
file1 = args.first 
file2 = args.second
sample = args.sample
sys.stdout = open(sample+"_output.txt", "w")
def chunks(l,n):
    for i in range(0, len(l), n):
        yield l[i:i + n]
def read_file(filename):
    position_list = []
    allele_list = []
    base_list = []
    with open(filename) as file:
        data = csv.reader(file, delimiter="\t")
        next(data, None)
        for line in data:
            position_list.append(line[1])
            allele_list.append(line[7])
            base_list.append(line[3:5])
        file.close()

    position_list = [i.replace(" ","")for i in position_list]
    updated_allele_list = []
    base_list = [item for sublist in base_list for item in sublist]
    base_list = [i.replace(" ","") for i in base_list]
    bases = chunks(base_list,2)
    bases = [":".join(i) for i in bases]
    # print(bases)

    for i in allele_list:
        i = i.split(";")[1].strip("AF=")
        updated_allele_list.append(i)
    updated_allele_list = [float(i) for i in updated_allele_list]
    #updated_allele_list = [math.log10(i) for i in updated_allele_list]
    #updated_allele_list = [i ** 2 for i in updated_allele_list]
    return position_list, updated_allele_list, bases


print("Location"+","+"Allele_Frequency_Sample_1"+","+"Allele_Frequency_Sample_2"+","+"Description"+","+"Sample")
mutation_1 = read_file(file1)[2]
pos_1 = read_file(file1)[0]
location_file_one = []
for a, b in zip(pos_1,mutation_1):
    location_file_one.append(a+":"+b)

mutation_2 = read_file(file2)[2]
pos_2 = read_file(file2)[0]
location_file_two = []
for a, b in zip(pos_2, mutation_2):
    location_file_two.append(a+":"+b)

af_file_one = read_file(file1)[1]
af_file_two = read_file(file2)[1]

dictionary_file1 = dict(zip(location_file_one,af_file_one))
dictionary_file2 = dict(zip(location_file_two,af_file_two))
#'''
#Going to loop through the second dict to get values 1 < i < 10 and values > 10.
#I loop through the first one a couple of lines later
#'''
file_2_one = 0
file_2_ten = 0
for i in dictionary_file2:
    if 0.01 <= dictionary_file2[i] < 0.1:
        file_2_one += 1
    if dictionary_file2[i] >= 0.1:
        file_2_ten += 1

unique_dict1 = copy.deepcopy(dictionary_file1)
unique_dict2 = copy.deepcopy(dictionary_file2)
array_1 = []
array_2 = []
shared_array = []
file_1_one = 0
file_1_ten = 0
for i in dictionary_file1:
    if 0.01 <= dictionary_file1[i] < 0.1:
        file_1_one += 1
    if dictionary_file1[i] >= 0.1:
        file_1_ten += 1

    if i in dictionary_file2:
        print(str(i)+","+str(dictionary_file1[i])+","+str(dictionary_file2[i])+","+"Shared"+","+str(sample))
        array_1.append(dictionary_file1[i])
        array_2.append(dictionary_file2[i])
        shared_array.append(dictionary_file2[i])
        del unique_dict1[i]
        del unique_dict2[i]

mishared_file1_one = 0
mishared_file1_ten = 0
mishared_file2_ten = 0
mishared_file2_one = 0
for i, j in zip(array_1,array_2):
    if i >= 0.1 and j<0.1:
        mishared_file1_ten += 1
    elif i >= 0.01 and j<0.01:
        mishared_file1_one += 1
    elif j >= 0.1 and i<0.1:
        mishared_file2_ten += 1
    elif j >= 0.01 and i<0.01:
        mishared_file2_one += 1

for i in unique_dict1:
    print(str(i)+","+str(dictionary_file1[i])+","+"0"+","+"file_1"+","+str(sample))
    array_1.append(dictionary_file1[i])
    array_2.append(float(0))
for i in unique_dict2:
    print(str(i)+","+"0"+","+str(dictionary_file2[i])+","+"file_2"+","+str(sample))
    array_1.append(float(0))
    array_2.append(dictionary_file2[i])


#####
sys.stdout.close()
sys.stdout = sys.__stdout__
sys.stdout = open(str(sample)+"_stats.txt","w")

#Get sum of squared score
sum_of_squares = []
for a, b in zip(array_1, array_2):
    sum_of_squares.append(math.sqrt((a-b)**2))

#'''
#The print statements which will go into the .stat file.
#'''
print("======\t"+file1+"\t======")
print("\tTotal SNPs:\t"+str(len(dictionary_file1)))
print("\tUnique SNPs:\t"+str(len(unique_dict1))+"\n")
print("\tGreater than or equal to 10%:\t"+str(file_2_ten))
print("\tGreater than 1% less than 10%:\t"+str(file_2_one)+"\n")
print("\tMishared 10% SNPs:\t"+str(mishared_file1_ten))
print("\tMishared 1% SNPs:\t"+str(mishared_file1_one)+"\n")
print("======\t"+file2+"\t======")
print("\tTotal SNPs:\t"+str(len(dictionary_file2)))
print("\tUnique SNPs:\t"+str(len(unique_dict2))+"\n")
print("\tGreater than or equal to 10%:\t"+str(file_2_ten))
print("\tGreater than 1% less than 10%:\t"+str(file_2_one)+"\n")
print("\tMishared 10% SNPs:\t"+str(mishared_file2_ten))
print("\tMishared 1% SNPs:\t"+str(mishared_file2_one)+"\n")

print("SNPs shared between two files:\t"+str(len(shared_array)))
print("Sum of squares score beteen two file:\t"+str(sum(sum_of_squares)))
x = (stats.spearmanr(array_1,array_2))
print("Spearmans Correlation value:\t"+str(x[0]))
print("Spearmans P-value:\t"+str(x[1]))
