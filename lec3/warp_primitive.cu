#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <iostream>
#include <bitset>

__global__ void
warp_instruction (int *a, int *any, int *all, int *ballot, int *popc, int len)
{
	int tid = threadIdx.x + blockIdx.x * blockDim.x;
	assert(blockDim.x * gridDim.x == 32);
    any[tid] = __any(a[tid]);
    all[tid] = __all(a[tid]);
    ballot[tid] = __ballot(a[tid]);
    popc[tid] = __popc(ballot[tid]);
}


    int
main (int args, char **argv)
{
    int len = 32;
    int *a = new int[len];
    int *any = new int[len];
    int *all = new int[len];
    int *ballot = new int[len];
    int *popc = new int[len];

    std::cout<<"Input data: \n";
    for (int i = 0; i < len; i++)
    {
        a[i] = rand () % 10;
        std::cout<<a[i]<<" ";
    }
    std::cout<<"\n";

    int *a_d, *any_d, *all_d, *ballot_d, *popc_d;

    cudaMalloc ((void **) &a_d, sizeof (int) * len);
    cudaMalloc ((void **) &any_d, sizeof (int) * len);
    cudaMalloc ((void **) &all_d, sizeof (int) * len);
    cudaMalloc ((void **) &ballot_d, sizeof (int) * len);
    cudaMalloc ((void **) &popc_d, sizeof (int) * len);

    cudaMemcpy (a_d, a, sizeof (int) * len, cudaMemcpyHostToDevice);
    warp_instruction <<< 1, 32 >>> (a_d, any_d, all_d, ballot_d, popc_d, len);

    cudaMemcpy (any, any_d, sizeof (int) * len, cudaMemcpyDeviceToHost);
    cudaMemcpy (all, all_d, sizeof (int) * len, cudaMemcpyDeviceToHost);
    cudaMemcpy (ballot, ballot_d, sizeof (int) * len, cudaMemcpyDeviceToHost);
    cudaMemcpy (popc, popc_d, sizeof (int) * len, cudaMemcpyDeviceToHost);

    std::cout<<"any       all          ballot          popc:\n";
    for(int i = 0; i < len; i ++)
    std::cout<<"Thread "<<i<<": "<<any[i]<<" "<<all[i]<<" "
            <<std::bitset<32>(ballot[i])<<" "<<popc[i]<<"\n";
    return 0;
}
