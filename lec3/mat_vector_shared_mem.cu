#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include "../helper/util.h"
#include "../helper/wtime.h"
#include <assert.h>

	__global__ void
gpu_mat_vec_multiply(int *mat, int *vec, int *res, int num_rows, int num_cols)
{

	int tid = threadIdx.x + blockIdx.x * blockDim.x;
	while (tid < num_rows)
	{
		int temp_res = 0;
		for (int j = 0; j < num_cols; j ++)
		{
			temp_res += mat[tid * num_cols + j] * vec[j];
		}

		res[tid] = temp_res;
		tid += blockDim.x * gridDim.x;
	}
}

	__global__ void
gpu_mat_vec_multiply_shared(int *mat, int *vec, int *res, int num_rows, int num_cols)
{
    __shared__ int smem[256];
    
    assert(num_cols<=256);
    smem[threadIdx.x] = vec[threadIdx.x];

	int tid = threadIdx.x + blockIdx.x * blockDim.x;
	while (tid < num_rows)
	{
		int temp_res = 0;
		for (int j = 0; j < num_cols; j ++)
		{
			temp_res += mat[tid * num_cols + j] * smem[j];
		}

		res[tid] = temp_res;
		tid += blockDim.x * gridDim.x;
	}
}



	void
mat_vec_multiply(int *mat, int *vec, int *res, int num_rows, int num_cols)
{
	for(int i = 0; i < num_rows; i ++)
	{
		int temp_res = 0;
		for (int j = 0; j < num_cols; j ++)
		{
			temp_res += mat[i * num_cols + j] * vec[j];
		}

		res[i] = temp_res;
	}
}

int main (int args, char **argv)
{
	int num_rows = 256;
	int num_cols = 256;

	int *mat = (int *)malloc(sizeof(int) * num_rows * num_cols);
	int *vec = (int *)malloc(sizeof(int) * num_cols);
	int *res = (int *)malloc(sizeof(int) * num_rows);


	//init matrix
	for (int i = 0; i < num_rows; i++)
	{
		for(int j = 0; j < num_cols; j++)
			mat[i*num_cols + j] = rand() % 4 + 1;
	}

	//init vector
	for (int i = 0; i < num_cols; i++)
	{
		vec[i] = rand() % 3 + 1;
	}


	//conduct matrix vector multiplication
	mat_vec_multiply(mat, vec, res, num_rows, num_cols);






	int *mat_d, *vec_d, *res_d, *res_gpu;
	H_ERR(cudaMalloc ((void **) &mat_d, sizeof (int) * num_rows * num_cols));
	H_ERR(cudaMalloc ((void **) &vec_d, sizeof (int) * num_cols));
	H_ERR(cudaMalloc ((void **) &res_d, sizeof (int) * num_rows));
	res_gpu = (int *)malloc(sizeof(int) * num_rows);


	H_ERR(cudaMemcpy (mat_d, mat, sizeof (int) * num_rows * num_cols, cudaMemcpyHostToDevice));
	H_ERR(cudaMemcpy (vec_d, vec, sizeof (int) * num_cols, cudaMemcpyHostToDevice));

    gpu_mat_vec_multiply_shared <<< 256, 256 >>> (mat_d, vec_d, res_d, num_rows, num_cols);
	H_ERR(cudaMemcpy (res_gpu, res_d, sizeof (int) * num_rows, cudaMemcpyDeviceToHost));
	assert(memcmp(res_gpu, res, sizeof(int) * num_rows) == 0);
	std::cout<<"Shared Succeed !\n";
	
    
    gpu_mat_vec_multiply <<< 256, 256 >>> (mat_d, vec_d, res_d, num_rows, num_cols);
    H_ERR(cudaMemcpy (res_gpu, res_d, sizeof (int) * num_rows, cudaMemcpyDeviceToHost));
	assert(memcmp(res_gpu, res, sizeof(int) * num_rows) == 0);
	std::cout<<"Global Succeed !\n";

	return 0;
}
