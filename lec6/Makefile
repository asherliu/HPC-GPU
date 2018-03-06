exe=perceptron.bin

cc="$(shell which g++)"
cucc="$(shell which nvcc)"
flags= -O3

objs	= $(patsubst %.cpp,%.o,$(wildcard *.cpp))

deps	= $(wildcard ./*.hpp) \
	  $(wildcard ./*.h) \
	  Makefile

%.o:%.cpp $(deps)
	$(cucc) -c $(flags) $< -o $@

$(exe):$(objs)
	$(cucc) $(objs) $(flags) -o $(exe)
	
test:$(exe)
	./$(exe) 20

clean:
	rm -rf *.o ${exe}
