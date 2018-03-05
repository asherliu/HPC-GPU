#include "wtime.h"
#include "reader.hpp"
#include "perceptron.hpp"

#define DIMENSION 61 


void predict(float* &W, float &b, float *data, int count, int dimension)
{
    for(int i = 0; i < count/dimension; i++)
    {
        float predict = 0;
        float expected = data[i*dimension + dimension - 1];

        for(int j = 0; j < dimension - 1; j ++)
            predict += W[j] * data[i*dimension + j] + b;

        if (predict < 0) predict = -1;
        else predict = 1;

        std::cout<<"Expect "<<expected<<", predict "<<predict<<"\n";
    }
}

int main(int args, char **argv)
{

    std::cout<<"/path/to/exe epoch\n";

    const int EPOCH = atoi(argv[1]);

    assert(args == 2);
    float *train_data;
    int train_count;

    float *test_data;
    int test_count;
    
    float *W;
    float b;

    reader("dataset/train_data.bin", train_data, train_count);
    reader("dataset/test_data.bin", test_data, test_count);
    
    //printer(train_dataset, train_count, DIMENSION);
    //printer(test_dataset, test_count, DIMENSION);
    

    perceptron_seq(W, b, train_data, train_count, DIMENSION, EPOCH);
    predict(W, b, test_data, test_count, DIMENSION);
    
    printer(W, DIMENSION - 1, 1);
    return 0;
}



