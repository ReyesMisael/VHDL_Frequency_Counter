#include<windows.h>
#include<stdlib.h>
#include<stdio.h>
#include<unistd.h>
#include<Winbase.h>
#include<iterator>
typedef unsigned long long int ull;
typedef unsigned int uint;				//TypeDef of gray number
unsigned char GrayToBinary(unsigned char num);
uint GrayToBinary2(uint num);

void PrintCommState(DCB dcb){				//Serial Port State
	printf("\nbaudrate = %lu ", dcb.BaudRate);
	printf("ByteSize = %d ", dcb.ByteSize);
	printf("Parity = %d ", dcb.Parity);
	printf(" StopBits = %d\n", dcb.StopBits);
}
void voltear(char* arreglo);
int main() {
	char Start = ' ';
	int k = 0;
	uint number = 0;
	HANDLE hComm;
	DCB serialParams;
	char recibido;
	//char buffer[2];
	unsigned int nx = 0;
	unsigned int no = 0;
	unsigned char buffer2[4];
	unsigned char bytes[sizeof buffer2];
	long unsigned int n, written;
	BOOL statusReceive, statusSent, fsuccess;
	unsigned int recibido32;
	//unsigned long long int recibido64;
	//unsigned long long int recibido64_2;
		hComm = CreateFileA("\\\\.\\COM3",		//Create a file to read and write 
			GENERIC_READ | GENERIC_WRITE,
			0,
			NULL,
			OPEN_EXISTING,
			0,
			NULL);
	memset(&serialParams,0, sizeof(DCB));	
	serialParams.DCBlength = sizeof(DCB);
	fsuccess = GetCommState(hComm,&serialParams);
	if (!fsuccess){
		printf("SetCommState failed with error %lu.\n",GetLastError());
		return (4);
	}
	PrintCommState(serialParams);
	serialParams.BaudRate = CBR_115200;
	serialParams.ByteSize = 8;
	serialParams.Parity = NOPARITY;
	serialParams.StopBits = ONESTOPBIT;
	fsuccess = SetCommState(hComm,&serialParams);
	if (!fsuccess){
		printf("SetCommState failed with error %lu.\n",GetLastError());
		return (3);
	}
	fsuccess = GetCommState(hComm,&serialParams);
	if (!fsuccess){
		printf("SetCommState failed with error %lu.\n",GetLastError());
		return (3);
	}
	BOOL statuspurge = PurgeComm(hComm, PURGE_RXABORT | PURGE_RXCLEAR);
	if(!statuspurge) {
		printf("PurgeComm failed with error %lu.\n",GetLastError());
		return (2);
	}
	//FPGA Start signal
	statusSent = WriteFile(hComm, &Start, 1, &written, NULL);
	sleep(2);
	//statusSent = WriteFile(hComm, &stop, 1, &written, NULL);
	statusReceive = ReadFile(hComm, &recibido, sizeof(char), &n, NULL);
	if(hComm == INVALID_HANDLE_VALUE){
		printf("Error in opening serial port\n");
		return (1);
	}
	else {
		printf("opening serial port successful\n");
		printf("hex,nx(i),no(i),nx(i) - nx(i-1),no(i) - no(i-1),Mt\n");
	}

	while(statusReceive && statusSent) {
		statusReceive = ReadFile(hComm,&buffer2,sizeof(uint),&n,NULL);
		if(n == 4) {
			recibido32 = *(unsigned int*) (&buffer2);
			printf("%x   ",recibido32); 
			nx = *((unsigned int*) (&buffer2)) & 0xFFFF; 	//lsb
			no = *((unsigned int*) (&buffer2[2]));		//msb
			printf("%d     %d", (uint) GrayToBinary2(nx),(uint) GrayToBinary2(no));
			printf("\n");
		}	
		else {
			recibido = 200;
		}
	}
	printf("Error with serial Port connnection\n");
	CloseHandle(hComm);			//Closing the Serial Port
	return 0;
}
unsigned char GrayToBinary (unsigned char num) {
	unsigned char mask = num;
	while (mask){
		mask >>=1;
		num  ^= mask;
	}
	return num;
}
uint GrayToBinary2(uint num)
{
    uint mask = num;
    while (mask) {           // Each Gray code bit is exclusive-ored with all more significant bits.
        mask >>= 1;
        num   ^= mask;
    }
    return num;
}
