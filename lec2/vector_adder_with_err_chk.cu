#include "../helper/util.h"

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>


__global__ void
vec_add_kernel (int *a, int *b, int *c, int len)
{
  int tid = threadIdx.x + blockIdx.x * blockDim.x;
  while (tid < len)
    {
      c[tid] = a[tid] + b[tid];
      tid += blockDim.x * gridDim.x;
    }
}


int
main (int args, char **argv)
{
  int len = (2<<28);
  int *a = new int[len];
  int *b = new int[len];
  int *c = new int[len];
  for (int i = 0; i < len; i++)
    {
      a[i] = rand () % 1024;
      b[i] = rand () % 512;
    }

  int *a_d, *b_d, *c_d;

  H_ERR(cudaMalloc ((void **) &a_d, sizeof (int) * len));
  H_ERR(cudaMalloc ((void **) &b_d, sizeof (int) * len));
  H_ERR(cudaMalloc ((void **) &c_d, sizeof (int) * len));

  H_ERR(cudaMemcpy (a_d, a, sizeof (int) * len, cudaMemcpyHostToDevice));
  H_ERR(cudaMemcpy (b_d, b, sizeof (int) * len, cudaMemcpyHostToDevice));
  vec_add_kernel <<< 256, 256 >>> (a_d, b_d, c_d, len);

  H_ERR(cudaMemcpy (c, c_d, sizeof (int) * len, cudaMemcpyDeviceToHost));

  for (int i = 0; i < len; i++)
    assert ((a[i] + b[i]) == c[i]);

  printf ("Succeed!\n");
  return 0;
}
