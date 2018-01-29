#!/bin/bash


nvcc -arch=sm_20 gpu_property.cu -o gpu_property

nvcc -arch=sm_20 vector_adder.cu -o vector_adder
 
nvcc -arch=sm_20 vector_adder_with_err_chk.cu -o vector_adder_with_err_chk

nvcc -arch=sm_20 vector_adder_with_err.cu -o vector_adder_with_err
