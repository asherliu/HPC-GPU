#!/bin/bash


nvcc -arch=sm_20 gpu_property.cu -o gpu_property.bin

nvcc -arch=sm_20 vector_adder.cu -o vector_adder.bin
 
nvcc -arch=sm_20 vector_adder_with_err_chk.cu -o vector_adder_with_err_chk.bin

nvcc -arch=sm_20 vector_adder_with_err.cu -o vector_adder_with_err.bin
