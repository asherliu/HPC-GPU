#ifndef __PERCEPTRON_HPP__
#define __PERCEPTRON_HPP__

#include <stdio.h>
#include <iostream>

void init_update(float *update_w, float update_b, int size)
{
    for(int i = 0; i < size; i ++)
        update_w[i] = 0;
    update_b = 0;
}


float error(float *update_w, int size)
{
    float err = 0;
    
    for(int i = 0; i < size; i ++)
        err += abs(update_w[i]);

    return err/size;
}


void perceptron_seq(float* &W, float &b, float *data, int count, int dimension, int epoch)
{
    int sample_count = count / dimension;

    W = new float[dimension - 1];
    b = 0;

    for(int i = 0; i < dimension - 1; i++)
        W[i] = 0;


    //batch updates
    float *update_w = new float[dimension -1];
    float update_b;


    for(int trial = 0; trial < epoch; trial ++)
    {
        init_update(update_w, update_b, dimension - 1);

        for(int i = 0; i < count/dimension; i ++)
        {
            float predict = 0;
            float expected = data[i*dimension + dimension - 1];

            //make prediction
            for(int j = 0; j < dimension - 1; j ++)
                predict += W[j] * data[i*dimension +j] + b;
            
            //apply sign function
            if (predict < 0) predict = -1;
            else predict = 1;
            
            //batch the updates to the model
            if (predict != expected) 
            {
                for(int j = 0; j < dimension - 1; j ++)
                    update_w[j] += (data[i*dimension +j] * expected/sample_count);
                update_b += (expected/sample_count);
            }
        }

        //if(error(update_w, dimension - 1) < 0.001 && update_b < 0.001)
        //    break;
        //else
        //{
        //apply updates to the model
            for(int j = 0; j < dimension - 1; j ++)
                W[j] += update_w[j];
            b += update_b;
        //}
    }

    delete[] update_w;
}

#endif
