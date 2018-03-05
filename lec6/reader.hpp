#ifndef __READER_H__
#define __READER_H__
#include <assert.h>
#include <iostream>
#include <stdio.h>
#include <sys/stat.h>

inline off_t fsize(const char *filename) {
    struct stat st; 
    if (stat(filename, &st) == 0)
        return st.st_size;
    return -1; 
}

void printer(float *data, int count, int dimension)
{
    assert(count%dimension == 0);
    for(int i = 0; i < count; i++)
    {
        if(i%dimension == 0)
            std::cout<<"\nData "<<i/dimension<<": ";
        std::cout<<data[i]<<" ";
    }
    std::cout<<"\n";
}


void reader(const char *filename, float* &data, int &count){
    count = 0;
    count = fsize(filename)/sizeof(float);
    
    assert(count>0);

    data = new float[count];

    FILE *file = NULL;
    int ret = -1;

    file = fopen(filename, "rb");
    ret = fread(data, sizeof(float), count, file);

    assert(ret == count);

    std::cout<<"Reading from "<<filename<<" with "<<count<<" entries\n";
    return;
}

#endif
