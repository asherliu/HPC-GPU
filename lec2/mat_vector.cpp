#include <iostream>
#include <stdio.h>
#include <stdlib.h>


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
    int num_rows = 4;
    int num_cols = 2;

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
    
    std::cout<<"Input matrix: \n";
    for (int i = 0; i < num_rows; i++)
    {
        for(int j = 0; j < num_cols; j++)
            std::cout<<mat[i*num_cols + j]<<" ";

        std::cout<<"\n";
    }

    std::cout<<"Input vector: \n";
    for (int i = 0; i < num_cols; i++)
    {
        std::cout<<vec[i]<<"\n";
    }


    std::cout<<"Result: \n";
    for (int i = 0; i < num_rows; i++)
    {
        std::cout<<res[i]<<"\n";
    }



    return 0;
}
