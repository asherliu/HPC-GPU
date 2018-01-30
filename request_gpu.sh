#!/bin/bash
bsub -q gpu  -R "select[gpu_model0=TeslaC2075]" -R rusage[mem=128000] -W 2:00 -Is bash
