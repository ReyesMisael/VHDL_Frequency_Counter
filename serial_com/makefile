CC=g++
CFLAGS=-Wall -g
DIR=./src
OBJ = pserial.o
all:  serial.exe
serial.exe:	$(OBJ)
		$(CC) $(CFLAGS) -o serial pserial.o
pserial.o:	$(DIR)/pserial.cpp
		$(CC) $(CFLAGS)	-c $(DIR)/pserial.cpp 
clean:
	rm -rf *.o *.exe
