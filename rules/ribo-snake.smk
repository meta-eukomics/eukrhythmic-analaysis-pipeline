configfile: "config.yaml"

import io
import os
from os import listdir
import glob
from snakemake.exceptions import print_exception, WorkflowError
import sys
sys.path.insert(1, '../scripts')
from importworkspace import *


rule ribodetector:
    input:
        r1 = lambda filename: expand(os.path.join(OUTPUTDIR, "{sample}_1.trimmed.fastq.gz"),
        r2 = lambda filename: expand(os.path.join(OUTPUTDIR, "{sample}_2.trimmed.fastq.gz")
    output:
        p1 = os.path.join(OUTPUTDIR, "intermediate-files", "01-setup",\
                          "02-trim",\
                          "{sample}_1.nonrRNA.fastq.gz"),
        p2 = os.path.join(OUTPUTDIR, "intermediate-files", "01-setup",\
                          "02-trim",\
                          "{sample}_2.nonrRNA.fastq.gz")
    log:
        err = os.path.join(OUTPUTDIR, "logs",\ 
                           "01-setup", "02-trim",\ 
                           "ribo_{sample}_err.log"),
        out = os.path.join(OUTPUTDIR, "logs",\
                           "01-setup", "02-trim",\
                           "ribo_{sample}_out.log")
    conda: os.path.join("..", "envs", "01-setup-env.yaml")
    shell:
        '''
	ribodetector_cpu -t 20 -l 151 -i {input.r1} {input.r2} -e rrna --chunk_size 128 -o {output.p1} {output.p2} 2> {log.err} 1> {log.out}
        '''
        
