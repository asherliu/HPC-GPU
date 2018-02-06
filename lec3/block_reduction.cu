#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <iostream>
#include <bitset>

__global__ void
block_reduction (int *a, int len)
{
    __shared__ int smem[256];
	assert(blockDim.x <= 256);


    smem[threadIdx.x] = threadIdx.x;

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

    a[threadIdx.x] = smem[0];
}


    int
main (int args, char **argv)
{
    int len = 256;
    int *a = new int[len];

   int *a_d;

    cudaMalloc ((void **) &a_d, sizeof (int) * len);

    block_reduction <<< 1, len >>> (a_d, len);

    cudaMemcpy (a, a_d, sizeof (int) * len, cudaMemcpyDeviceToHost);

    std::cout<<"Block id sum: "<< a[0]<<"\n";
    
    int sum = 0;
    for (int i = 0; i < 256; i ++)
        sum += i;

    std::cout<<"Correct result: "<<sum<<"\n";
    return 0;
}
