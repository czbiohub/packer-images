#!/usr/bin/env python

###########################################################
# Tool for generating primers after CRISPR cutting
# Inputs:
# 1. get the spacer location from andy in the form of following
#       name/reference genome (hg38 or mm10) location
# 2. primer3 configuration file
# 3. other configuration related to the PCR product length
# Steos:
# 1. lookup the sequences from input 1.
# 2. find primers based on above and input 2.
# 3. check specificity
# 4. check the spacer location
# 5. output
# Detailed spec: https://docs.google.com/document/d/1h_QOtsH6_uH5VeOCr0dBcUBFnQyamgpdQmupYWyvxo8/edit
################################################


import argparse
import csv
import hashlib
import os
import subprocess
import sys
import time

from fastinterval import Genome, Interval

IDEAL_TM_MIN = 57
IDEAL_TM_MAX = 63
IDEAL_PRIMER_LEN_MIN = 18
IDEAL_PRIMER_LEN_MAX = 25
IDEAL_AMPLICON_GC_MIN = 30
IDEAL_AMPLICON_GC_MAX = 75
IDEAL_HOMOPOLY_MAX = 4

ACCEPTABLE_AMPLICON_GC_MIN = 25
ACCEPTABLE_AMPLICON_GC_MAX = 75
ACCEPTABLE_HOMOPOLY_MAX = 5

LEFT_TAG = 'CTCTTTCCCTACACGACGCTCTTCCGATCT'
RIGHT_TAG = 'CTGGAGTTCAGACGTGTGCTCTTCCGATCT'

SEARCH_RANGE = 220
CRISPR_CUT_IDX = 4

LOW_COMPLEXITY_CHECK_N = 10
DBSNP_CHECK_N = 8

CUTSITE_OFFSET_END = 50
CUTSITE_OFFSET_MIDDLE = 15


MAX_ISPCR_SEARCH_SIZE = 3000

CODE_IDEAL = 1
CODE_ACCEPTABLE = 2
CODE_NQ = None

PRIMER3_SETTINGS_FILE = 'primer3_settings.cnf'

SNP_POSTFIX = '-snp142'

# DATA_FILE_DIR = '/data/hca/genome'
DATA_FILE_DIR = 'genome'
GENOME_FASTA = {'hg38': DATA_FILE_DIR + '/hg38.fa',
                'mm10': DATA_FILE_DIR + '/mm10.fa',
                'hg38-snp142': DATA_FILE_DIR + '/hg38.snp142.fa',
                'mm10-snp142': DATA_FILE_DIR + '/mm10.snp142.fa',
                }
BLAT_DIR = 'blat'
GF_SERVER_PORT = 7988
GFPCR_DIR = 'isPcr'


def get_top_primers(seq_name, genome, spacer_location, search_range, crispr_cut_position):
    '''Main function to get top primers given a spacer location '''
    # Example: get_top_primers('sequence-1', 'hg38', 'chr1:23358-23378', 220, 4)
    GENOME = Genome(GENOME_FASTA[genome])
    SNP_GENOME = Genome(GENOME_FASTA[genome + SNP_POSTFIX])
    (chromosome, spacer_range) = spacer_location.split(':')
    (spacer_left, spacer_right) = spacer_range.split('-')
    spacer_left = int(spacer_left)
    spacer_right = int(spacer_right)
    left_end = spacer_left - search_range
    right_end = spacer_right + search_range
    crispr_cut_site = spacer_right - crispr_cut_position  # index of the last nucleite on the left
    spacer_length = spacer_right - spacer_left

    ginterval = GENOME.interval(left_end, right_end, chrom=chromosome)
    spacer_seq = GENOME.interval(spacer_left, spacer_right, chrom=chromosome).sequence
    spacer_display = GENOME.interval(spacer_left, spacer_right, chrom=chromosome).sequence
    snp_interval = SNP_GENOME.interval(left_end, right_end, chrom=chromosome)

    crispr_cut_in_sequence = crispr_cut_site - left_end
    spacer_left_in_sequence = spacer_left - left_end
    primer3_content = '''SEQUENCE_ID=%s
SEQUENCE_TEMPLATE=%s
SEQUENCE_TARGET=%d,%d
SEQUENCE_INTERNAL_EXCLUDED_REGION=%d,%d
=
''' % (seq_name, ginterval.sequence, spacer_left_in_sequence, spacer_length, spacer_left_in_sequence, spacer_length)

    primer3_file_name = hashlib.md5(seq_name).hexdigest() + '.primer3'
    with open(primer3_file_name, 'wb') as fh:
        fh.write(primer3_content)
    command = "primer3_core -p3_settings_file=%s %s" % (PRIMER3_SETTINGS_FILE, primer3_file_name)
    print command
    primer3_output = subprocess.check_output(command, shell=True)
    parsed_results = parse_primer3_results(primer3_output)
    parsed_results = get_ispcr_results(seq_name, parsed_results)

    # remove the primer3_file
    command = "rm -rf %s" % primer3_file_name
    print command
    output = subprocess.check_output(command, shell=True)

    # return parsed_results
    acceptable = []
    for parsed in parsed_results:
        parsed['spacer'] = spacer_seq
        parsed['spacer_display'] = spacer_display
        parsed['left_end'] = left_end
        parsed['chromosome'] = chromosome
        code = check_primer3_result(parsed, crispr_cut_in_sequence, spacer_left_in_sequence, snp_interval.sequence)
        if code == CODE_IDEAL:
            return parsed
        elif code == CODE_ACCEPTABLE:
            acceptable.append(parsed)
    if len(acceptable) > 0:
        print "No ideal matches. %d acceptable matches" % len(acceptable)
        return acceptable[0]
    return None  # no matches


def check_primer3_result(parsed, crispr_cut_in_sequence, spacer_left_in_sequence, snp_interval):
    ret_code = CODE_IDEAL
    left_primer = parsed['left_primer']
    right_primer = parsed['right_primer']
    product_loc = int(parsed['product_loc'].split(',')[0])
    product_size = int(parsed['product_size'])

    # Check specificity
    # check ispcr/BLAT
    ispcr_count = parsed.get('ispcr_count', 0)
    if ispcr_count != 1:
        print "%d ispcr match for primer: %s %s" % (ispcr_count, left_primer, right_primer)
        return CODE_NQ
    # check dbsnp
    snp_product = snp_interval[product_loc:(product_loc + product_size)]
    left_primer_snp = snp_product[:len(left_primer)]
    right_primer_snp = snp_product[-len(right_primer):]
    snp_n_left = num_snp_in_sequence(left_primer_snp[-DBSNP_CHECK_N:])
    snp_n_right = num_snp_in_sequence(right_primer_snp[:DBSNP_CHECK_N])
    if snp_n_left == 0 and snp_n_right == 0:
        print "No snps for primer: %s %s" % (left_primer, right_primer)
    elif snp_n_left <= 1 and snp_n_right <= 1:
        ret_code = CODE_ACCEPTABLE
    else:
        print "snps for primer: %s %s" % (left_primer_snp, right_primer_snp)
        return CODE_NQ

    # check complexity
    left_3end = left_primer[-LOW_COMPLEXITY_CHECK_N:]
    right_3end = right_primer[-LOW_COMPLEXITY_CHECK_N:]
    for c in (left_3end + right_3end):
        if c.islower():
            print "Low complexity for primer: %s %s" % (left_primer, right_primer)
            return CODE_NQ

    # check crispr cut-site with respect to amplicon
    cutsite_in_product = crispr_cut_in_sequence - product_loc
    print "cutsite in product %d: product size: %d" % (cutsite_in_product, product_size)
    # calculating acceptable cut site position
    middle = product_size / 2
    if cutsite_in_product < CUTSITE_OFFSET_END or \
            cutsite_in_product >= (product_size - CUTSITE_OFFSET_END):
        print "cut site %d at end for primer: %s %s" % (cutsite_in_product, left_primer, right_primer)
        return CODE_NQ
    if cutsite_in_product > (middle - CUTSITE_OFFSET_MIDDLE) and \
            cutsite_in_product <= (middle + CUTSITE_OFFSET_MIDDLE):
        print "cut site %d too close to middle for primer: %s %s" % (cutsite_in_product, left_primer, right_primer)
        return CODE_NQ

    # check self-binding primers
    last_4_left_com = complementary_sequence(left_primer[-4:])
    last_4_right_com = complementary_sequence(right_primer[::-1][:4])
    if last_4_left_com in right_primer[::-1].upper():
        return CODE_NQ
    if last_4_right_com in left_primer.upper():
        return CODE_NQ
    # check self-binding to self
    if last_4_left_com in left_primer.upper():
        return CODE_NQ
    if last_4_right_com in right_primer[::-1].upper():
        return CODE_NQ

    # check self-bindig with tags
    if last_4_left_com in (RIGHT_TAG + right_primer)[::-1].upper():
        return CODE_NQ
    if last_4_right_com in (LEFT_TAG + left_primer).upper():
        return CODE_NQ

    # check amplicon gc
    amplicon_gc_pct = get_gc_pct(parsed['product'])
    if amplicon_gc_pct < ACCEPTABLE_AMPLICON_GC_MIN or amplicon_gc_pct > ACCEPTABLE_AMPLICON_GC_MAX:
        print "amplicon gc %f too extreme for primer: %s %s" % (amplicon_gc_pct, left_primer, right_primer)
        return CODE_NQ
    elif amplicon_gc_pct < IDEAL_AMPLICON_GC_MIN or amplicon_gc_pct > IDEAL_AMPLICON_GC_MAX:
        ret_code = CODE_ACCEPTABLE

    # check max poly: (already filtered by primer 3 for 5)
    poly_max = max(get_poly_max(left_primer), get_poly_max(right_primer))
    if poly_max > ACCEPTABLE_HOMOPOLY_MAX:
        print "homopoly too  high for primer: %s %s" % (left_primer, right_primer)
        return CODE_NQ
    elif poly_max > IDEAL_HOMOPOLY_MAX:
        ret_code = CODE_ACCEPTABLE

    # check melting temperature
    if float(parsed['left_tm']) < IDEAL_TM_MIN or float(parsed['left_tm']) > IDEAL_TM_MAX:
        ret_code = CODE_ACCEPTABLE
    if float(parsed['right_tm']) < IDEAL_TM_MIN or float(parsed['right_tm']) > IDEAL_TM_MAX:
        ret_code = CODE_ACCEPTABLE

    # check primer size
    left_size = len(left_primer)
    right_size = len(right_primer)

    if left_size < IDEAL_PRIMER_LEN_MIN or left_size > IDEAL_PRIMER_LEN_MAX:
        ret_code = CODE_ACCEPTABLE
    if right_size < IDEAL_PRIMER_LEN_MIN or right_size > IDEAL_PRIMER_LEN_MAX:
        ret_code = CODE_ACCEPTABLE

    print "Yes. Primer qualified primer: %d %s %s" % (ret_code, left_primer, right_primer)
    return ret_code


def num_snp_in_sequence(snp_sequence):
    seq = snp_sequence.upper()
    snp_n = 0
    for c in seq:
        if c not in ['A', 'C', 'T', 'G']:
            snp_n += 1
    return snp_n


def complementary_sequence(seq):
    seq_map = {'A': 'T', 'T': 'A', 'C': 'G', 'G': 'C'}
    seq = seq.upper()
    res = ''
    for c in seq:
        res += seq_map[c]
    return res


def get_poly_max(sequence):
    sequence = sequence.upper()
    poly_max = 0
    current_bp = sequence[0]
    cnt = 1
    for i in range(1, len(sequence)):
        if sequence[i] == current_bp:
            cnt += 1
        else:
            if cnt > poly_max:
                poly_max = cnt
            cnt = 1
            current_bp = sequence[i]
    if cnt > poly_max:
        poly_max = cnt
    return poly_max


def get_gc_pct(sequence):
    n = float(len(sequence))
    p = 0
    for c in sequence.upper():
        if c in ['G', 'C']:
            p += 1
    return p / n * 100


def start_blat_server(genome):
    stop_blat_server()
    command = "%s/gfServer start localhost %d %s/%s.2bit" % (BLAT_DIR, GF_SERVER_PORT, DATA_FILE_DIR, genome)
    print command
    subprocess.Popen(command, shell=True)
    # Waiting for "Server ready for queries!"
    time.sleep(90)


def stop_blat_server():
    # check if server already started. if so, kill
    command = "ps ax|grep 'gfServer start localhost %d' |grep -v grep|cut -c1-6" % GF_SERVER_PORT
    print command
    res = subprocess.check_output(command, shell=True)
    pids = res.replace("\n", " ")
    if len(pids) > 3:
        # TODO (gdingle): this sometimes errors with invalid process id trailing the real one
        command = "kill -9 %s" % pids
        print command
        res = subprocess.check_output(command, shell=True)


def get_ispcr_results(seq_name, parsed_results):
    # composing the isPCR input file
    ispcr_filename = hashlib.md5(seq_name).hexdigest() + '.ispcr'
    with open(ispcr_filename, 'wb') as fh:
        for i in range(len(parsed_results)):
            parsed = parsed_results[i]
            line = "%d %s %s %d" % (i, parsed['left_primer'],
                                    parsed['right_primer'], MAX_ISPCR_SEARCH_SIZE)
            fh.write(line + "\n")
    command = "%s/gfPcr -minGood=16 localhost %d ./ %s stdout" % (GFPCR_DIR, GF_SERVER_PORT, ispcr_filename)
    print command
    res = subprocess.check_output(command, shell=True)
    print res
    lines = res.split("\n")
    for line in lines:
        if len(line) < 1 or line[0] != '>':
            continue
        fields = line.split(" ")
        idx = int(fields[1])
        parsed_results[idx]['ispcr_count'] = parsed_results[idx].get('ispcr_count', 0) + 1

    # remove the ispcr input file
    command = "rm -rf %s" % ispcr_filename
    print command
    output = subprocess.check_output(command, shell=True)

    return parsed_results


PRIMER3_KEY_MAP = {
    'left_primer': 'PRIMER_LEFT_%d_SEQUENCE',
    'right_primer': 'PRIMER_RIGHT_%d_SEQUENCE',
    'left_primer_loc': 'PRIMER_LEFT_%d',
    'right_primer_loc': 'PRIMER_RIGHT_%d',
    'left_tm': 'PRIMER_LEFT_%d_TM',
    'right_tm': 'PRIMER_RIGHT_%d_TM',
    'left_primer_gc': 'PRIMER_LEFT_%d_GC_PERCENT',
    'right_primer_gc': 'PRIMER_RIGHT_%d_GC_PERCENT',
    'product_size': 'PRIMER_PAIR_%d_PRODUCT_SIZE'
}


def parse_primer3_results(primer3_output):
    lines = primer3_output.split("\n")
    kv_hash = {}
    for line in lines:
        print line
        if len(line) < 3:
            continue
        (key, val) = line.split('=')
        kv_hash[key] = val
    sequence = kv_hash['SEQUENCE_TEMPLATE']
    sequence_target = kv_hash['SEQUENCE_TARGET']
    num_pairs = int(kv_hash['PRIMER_PAIR_NUM_RETURNED'])
    parsed_results = []
    for i in range(num_pairs):
        parsed = {}
        for key, name in PRIMER3_KEY_MAP.iteritems():
            iname = name % i
            parsed[key] = kv_hash[iname]
        # get the amplicon
        left_idx = int(parsed['left_primer_loc'].split(',')[0])
        right_idx = left_idx + int(parsed['product_size'])
        parsed['product_loc'] = "%d,%d" % (left_idx, int(parsed['product_size']))
        parsed['product'] = sequence[left_idx:right_idx]
        parsed['sequence'] = sequence
        parsed_results.append(parsed)
    return parsed_results


def derive_location(primer3_loc, left_end, chromosome):
    (relative_loc, length) = primer3_loc.split(",")
    start_location = left_end + int(relative_loc)
    end_location = start_location + int(length)
    return "%s:%d-%d" % (chromosome, start_location, end_location)


def main():
    description = '''Generating crispr primers.'''
    parser = argparse.ArgumentParser(
        description=description)
    parser.add_argument('-f', action="store", dest='input_spacer_sequences_file', default=False,
                        help="see example_input.bed.csv")
    parser.add_argument('-g', action="store", dest='genome', default=False,
                        help='mm10 or hg38')
    parser.add_argument('-o', action="store", dest='outputfile', default=False)
    parser.add_argument('-s', action="store", dest='search_range', default=SEARCH_RANGE,
                        help='default is %d before and after the cutsite' % SEARCH_RANGE)
    parser.add_argument('-n', action="store", dest='cut_idx', default=CRISPR_CUT_IDX,
                        help='default is %d' % CRISPR_CUT_IDX)
    results = parser.parse_args()
    if results.genome and results.input_spacer_sequences_file and results.outputfile:
        start_blat_server(results.genome)
        # searching for best primers
        res_hash = {}
        with open(results.input_spacer_sequences_file, 'r') as fh:
            idx = 0
            dropout_fh = open(results.outputfile + '.dropout', 'wb')
            dropout_writer = csv.writer(dropout_fh, delimiter=",")
            dropout_writer.writerow(['Well ID', 'Location'])
            for line in fh:
                line = line.rstrip()
                print "===================%s=======================" % line
                (well_id, location) = line.split(",")
                if location[0:3] != 'chr':
                    print "invalid line: %s" % line
                    continue
                res = get_top_primers(well_id, results.genome, location,
                                      int(results.search_range), int(results.cut_idx))
                print res
                if res:
                    res_hash[line] = res
                else:
                    "WARNING:%s doesn't have any good primer results" % line
                    dropout_writer.writerow([well_id, location])
                print "=============================================="
                idx += 1
            dropout_fh.close()
        with open(results.outputfile, 'wb') as fo:
            owriter = csv.writer(fo, delimiter=",")
            owriter.writerow(['Name', 'Genome', 'Spacer location', 'Spacer Sequence', 'Oriented Spacer',
                              'Left Primer Location', 'Left Primer',
                              'Right Primer Location', 'Right Primer',
                              'Product Size', 'Product Location', 'Product',
                              'Left Primer with Tag', 'Right Primer with Tag'])
            for (loc, res) in res_hash.iteritems():
                (name, spacer_loc) = loc.split(',')
                chromosome = res['chromosome']
                left_end = res['left_end']  # absolute location of left end of search range

                right_primer_loc = res['right_primer_loc']
                (right_loc, length) = right_primer_loc.split(",")
                left_loc = int(right_loc) - int(length) + 1
                right_primer_loc = "%d,%d" % (left_loc, int(length))
                spacer = res['spacer_display']
                if spacer[-2:] == 'GG':
                    spacer = '+' + spacer
                else:
                    spacer = '-' + spacer

                row = [name, results.genome, spacer_loc, res['spacer_display'], spacer,
                       derive_location(res['left_primer_loc'], left_end, chromosome),
                       res['left_primer'],
                       derive_location(right_primer_loc, left_end, chromosome),
                       res['right_primer'],
                       res['product_size'],
                       derive_location(res['product_loc'], left_end, chromosome), res['product'],
                       LEFT_TAG + res['left_primer'], RIGHT_TAG + res['right_primer']]
                owriter.writerow(row)
            # Outputing bed file
            with open(results.outputfile + '.bed', 'wb') as foo:
                bwriter = csv.writer(foo, delimiter="\t")
                bwriter.writerow(['# chromsome', 'spacer_loc_left', 'spcer_loc_right',
                                  'name', 'unknown', 'oritentation'])

                for (loc, res) in res_hash.iteritems():
                    (name, spacer_location) = loc.split(',')
                    (chromosome, spacer_range) = spacer_location.split(':')
                    (spacer_left, spacer_right) = spacer_range.split('-')
                    direction = '-'
                    spacer = res['spacer_display']
                    if spacer[-2:] == 'GG':
                        direction = '+'
                    row = [chromosome, spacer_left, spacer_right, name, 0, direction]
                    bwriter.writerow(row)

        stop_blat_server()
        time.sleep(5)
    else:
        parser.print_help()
        print ''' Example: ./crispr_primer.py -f example_input.bed.csv -g hg38 -o example_output.csv '''
        sys.exit(1)


if __name__ == "__main__":
    main()
