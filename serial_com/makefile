CC=g++
CFLAGS=-Wall -g
DIR=./src
OBJ = ch2bit.o pserial.o
all: Serial.exe
Serial.exe:	$(OBJ)
		$(CC) $(CFLAGS) -o Serial ch2bit.o pserial.o
pserial.o:	$(DIR)/pserial.cpp
		$(CC) $(CFLAGS)	-c $(DIR)/pserial.cpp 
ch2bit.o:	$(DIR)/ch2bit.cpp
		$(CC) $(CFLAGS)	-c $(DIR)/ch2bit.cpp
clean:
	rm -rf *.o *.exe
