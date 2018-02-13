#include <iostream>

__global__ void normal(int *a, int *b, int *c, int len)
{
	int myrow = blockIdx.x;
	__shared__ int smem[256];

	while(myrow <len)
	{
		for (int i = 0; i < len; i ++)//which col of right matrix
		{
			int tid = threadIdx.x;
			int res = 0;
			while( tid < len ) // vector vector multiplication
			{
				res += a[myrow*len + tid] * b[tid*len + i];
				tid += blockDim.x;
			}

			smem[threadIdx.x] = res;
			__syncthreads();
			for (int idx = blockDim.x/2; idx > 0; idx = idx/2)
			{
				if(threadIdx.x < idx)
				{
					int temp = smem[threadIdx.x] + smem[threadIdx.x + idx];
					smem[threadIdx.x] = temp;
				}
				__syncthreads();

			}

			c[myrow*len + i] = smem[0];
		}
	}

	myrow += gridDim.x;

}

__global__ void transpose(int *a, int *b, int *c, int len)
{
	int myrow = blockIdx.x;
	__shared__ int smem[256];

	while(myrow <len)
	{
		for (int i = 0; i < len; i ++)//which col of right matrix
		{
			int tid = threadIdx.x;
			int res = 0;
			while( tid < len ) // vector vector multiplication
			{
				res += a[myrow*len + tid] * b[i*len + tid];
				tid += blockDim.x;
			}
			smem[threadIdx.x] = res;
			__syncthreads();
			for (int i = blockDim.x/2; i > 0; i = i/2)
			{
				if(threadIdx.x < i)
				{
					int temp = smem[threadIdx.x] + smem[threadIdx.x + i];
					smem[threadIdx.x] = temp;
				}
				__syncthreads();

			}

			c[myrow*len + i] = smem[0];
		}

		myrow += gridDim.x;
	}
}
