#include<windows.h>
#include<stdlib.h>
#include<stdio.h>
#include<unistd.h>
#include<Winbase.h>
#include<cmath>
#include"ch2bit.h"
typedef unsigned int uint;
typedef unsigned long long int ull;
uint gen_mask(uint n);
void invertArray(unsigned char *array, size_t length);
uint GrayToBinary(uint num);
void PrintCommState(DCB dcb){				
	printf("\n Baudrate = %d, ByteSize = %d, Parity = %d, StopBits = %d \n",
			dcb.BaudRate,
			dcb.ByteSize,
			dcb.Parity,
			dcb.StopBits);
}
int main() {
	char toSend = ' ';							//Start to send information trigger
	unsigned int n = 16, mask;						//number of bits of each counter 
	int k;									
	HANDLE hComm;					
	DCB serialParams;
	bool select_code = true;						//Select true if data received is gray code
	unsigned char buffer[2];						
	long unsigned int bytessend, bytesread;
	long long unsigned int written;
	unsigned int number;									
	BOOL statusReceive, statusSend, fsuccess;
			hComm = CreateFileA("\\\\.\\COM3",
			GENERIC_READ | GENERIC_WRITE,
			0,
			NULL,
			OPEN_EXISTING,
			0,
			NULL);
	memset(&serialParams,0,sizeof(DCB));					//clear DCB 	
	serialParams.DCBlength = sizeof(DCB);					
	fsuccess = GetCommState(hComm, &serialParams);
	if (!fsuccess){
		printf("SetCommState failed with error %d.\n", GetLastError());
		return (3);

	}
 	//PrintCommState(serialParams);						//print current state of serial port
 	serialParams.BaudRate = CBR_115200;
	serialParams.ByteSize = 8;
	serialParams.Parity = NOPARITY;
	serialParams.StopBits = ONESTOPBIT;
	fsuccess = SetCommState(hComm, &serialParams);				//set the desired serial port parameters
	if (!fsuccess){
		printf("SetCommState failed with error %d.\n", GetLastError());
		return (2);
	}
	//PrintCommState(serialParams);					
	statusSend = WriteFile(hComm, &toSend, 1, &bytessend, NULL);		//FPGA trigger to start to send data
	sleep(2);								//Wait 
	statusReceive = ReadFile(hComm, &buffer, 2*sizeof(char), &bytesread, NULL);
	if(hComm == INVALID_HANDLE_VALUE) {
		printf("Error in opening serial port\n");
		return (1);
	}
	else {
		//printf("opening serial port successful\n");
		printf("hex_nx,nx(i),hex_no(i),no(i),\n");
	}
	k = 0;
	mask = gen_mask(n);
	while(statusReceive && statusSend) {
		statusReceive = ReadFile(hComm, &buffer, 2*sizeof(char), &bytesread, NULL);
		if (bytesread == 2) {
			number = *(unsigned int*) (&buffer);	
			number &= mask;					//true if source code is binary false to decode gray counter 
			if (select_code == false) {
				printf("%x,%d,",number,number);
				
			}else{
				invertArray(buffer, 2);
				number = *(unsigned int*) (&buffer);	
				number &= mask;				//true if source code is binary false to decode gray counter 
				printf("%x,%d,",number,GrayToBinary(number));
			}
			k++;
			if (k%2==0) printf("\n"); 		
		}
	}
	printf("Connection error\n");
	CloseHandle(hComm);			//Closing the Serial Port
	return (0);
}
uint GrayToBinary(uint num){
	uint mask = num;
	while(mask){
		mask >>= 1;
		num ^= mask;
	}
	return num;
}
uint gen_mask(uint n) {
	uint mask = 0, i;
	for(i = 0; i < n; i++) {
		mask |= (1 << i);
	}
	return mask;
}
void invertArray(unsigned char *array, size_t length) {
    size_t start = 0;
    size_t end = length - 1;
    while (start < end) {
        // Swap the elements
        unsigned char temp = array[start];
        array[start] = array[end];
        array[end] = temp;
        // Move towards the center
        start++;
        end--;
    }
}

