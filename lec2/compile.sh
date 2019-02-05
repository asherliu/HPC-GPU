#!/bin/bash


nvcc gpu_property.cu -o gpu_property.bin

nvcc vector_adder.cu -o vector_adder.bin
 
nvcc vector_adder_with_err_chk.cu -o vector_adder_with_err_chk.bin

nvcc vector_adder_with_err.cu -o vector_adder_with_err.bin
