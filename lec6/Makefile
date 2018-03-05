exe=perceptron.bin

cc="$(shell which g++)"
flags= -O3

objs	= $(patsubst %.cpp,%.o,$(wildcard *.cpp))

deps	= $(wildcard ./*.hpp) \
	  $(wildcard ./*.h) \
	  Makefile

%.o:%.cpp $(deps)
	$(cc) -c $(flags) $< -o $@

$(exe):$(objs)
	$(cc) $(objs) $(flags) -o $(exe)

clean:
	rm -rf *.o ${exe}
