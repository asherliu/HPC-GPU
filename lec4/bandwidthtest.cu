#include <iostream>
#define N (1<<23)
#include "../helper/wtime.h"

int main(int args, char **argv)
{
    int *a, *a_d;

    cudaMalloc((void **)&a_d, sizeof(int)*N);

    a = new int[N];

    double time = wtime();
    cudaMemcpy(a_d, a, sizeof(int)*N, cudaMemcpyHostToDevice);
    time = wtime() - time;

    std::cout<<"Bandwidth: "<<((N*4)>>20)/time<<" MB/s\n";

    return 0;
}
