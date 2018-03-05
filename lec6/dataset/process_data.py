from random import seed
from random import randrange
from csv import reader
import numpy as np

# Load a CSV file
def load_csv(filename):
    dataset = list()
    with open(filename, 'r') as file:
        csv_reader = reader(file)
        for row in csv_reader:
            if not row:
                continue
            dataset.append(row)
    return dataset

if __name__ == '__main__':
    data=load_csv("dataset.txt");
    train_data= list()
    test_data= list()

    for i in range(0,len(data)):
        if i%6==0:
            test_data.append(data[i])
        else:
            train_data.append(data[i])

    testd=np.array(test_data)
    testd=testd.astype('float32')
    testd.tofile("test_data.bin")

    traind=np.array(train_data)
    traind=traind.astype('float32')
    traind.tofile("train_data.bin")


    #print train_data

