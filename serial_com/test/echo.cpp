#include<windows.h>
#include<stdlib.h>
#include<stdio.h>
#include<unistd.h>
#include<Winbase.h>
typedef unsigned long long int ull;
void PrintCommState(DCB dcb){
	printf("\n baudrate = %lu ", dcb.BaudRate);
	printf("ByteSize = %d ", dcb.ByteSize);
	printf("Parity = %d ", dcb.Parity);
	printf(" StopBits = %d\n", dcb.StopBits);
}
void voltear(char* arreglo);
int main() {
	char Start = ' ';
	char stop = 0x00;
	char rstCount = 'c';
	char rstFIFO = 'f';
	char rstALL = 'r';

	HANDLE hComm;
	DCB serialParams;
	char recibido;
	char buffer[8];
	unsigned int a;
	unsigned int b;
	double frequency;
	const unsigned int To = 25000000;
	long unsigned int n, written;
	BOOL statusReceive, statusSent, fsuccess;
	unsigned long long int recibido64;
	unsigned long long int recibido64_2;
	printf("%u", sizeof(recibido64));
	hComm = CreateFileA("\\\\.\\COM3",
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
	//FPGA Start Sequence
	//statusSent = WriteFile(hComm, &rstALL, 1, &written, NULL);
	//sleep(3);
	//statusSent = WriteFile(hComm, &rstFIFO, 1, &written, NULL);
	//sleep(1);
	statusSent = WriteFile(hComm, &Start, 1, &written, NULL);
	sleep(2);
	statusSent = WriteFile(hComm, &stop, 1, &written, NULL);
	//sleep(1);

	statusReceive = ReadFile(hComm, &recibido, sizeof(char), &n, NULL);
	if(hComm == INVALID_HANDLE_VALUE){
		printf("Error in opening serial port\n");
		return (1);
	}
	else {
		printf("opening serial port successful\n");
		printf("hex,	nx(i),		no(i),		frequency,");
	}

	while(statusReceive && statusSent) {
		statusReceive = ReadFile(hComm, buffer, 8*sizeof(char), &n, NULL);
		if(n == 8) {
			recibido64 = *((unsigned long long int*) (&buffer));
			//for(int k = 0; k < 8; k++)
			//	printf("%i, %x\n", k, buffer[k]);
			a = *((unsigned int*) (&buffer));		//	Tx
			b = *((unsigned int*) (&(buffer[4])));		//	To
			float div = (float) a/b;
			frequency = (float) (div*To);
		}
		else {
			recibido = 200;
		}
		printf("%016I64x , ", recibido64);
		printf("%I32u ,", a);
		printf("%I32u ," , b);
		printf("%0.15f, \n",frequency);
	}
	printf("Error with serial Port connnection\n");
	CloseHandle(hComm);			//Closing the Serial Port
	return 0;
}
void voltear(char* arreglo) {
	int i = 0;
	char temp = 0;
	char temp2 = 0;
	char mask1 = 0x0f;
	char mask2 = 0xf0;
	for(i = 0; i < 8; i++) {
		temp ^= temp;
		temp2 ^= temp2;
		temp = arreglo[i] & mask1;
		temp2 = arreglo[i] & mask2;
		temp <<= 4;
		temp2 >>= 4;
		arreglo[i] = 0;
		arreglo[i] |= (temp & mask2);
		arreglo[i] |= (temp2 & mask1);
	}
	for(i = 0; i < 4; i++) {
		temp = arreglo[i];
		arreglo[i] = arreglo[7 - i];
		arreglo[7 - i] = temp;
	}
}
