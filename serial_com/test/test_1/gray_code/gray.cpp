#include<stdlib.h>
#include<stdio.h>

typedef unsigned int uint;
uint BinaryToGray(uint num);
uint GrayToBinary(uint num);

int main() {

	uint a;
	uint number = 0;
	uint buffer2 = 0xFFFF1111;
	uint recibido3 = 0;
	unsigned char buffer3[4] = {0xFF,0xFF,0x11,0x11};
	uint nx = 0;
	uint no = 0;
	uint recibido32 = 0;
	//scanf("%d", &a);
	a = 0xFFFF;
	number = BinaryToGray(a);
	printf("%x\n",number);
	number = GrayToBinary(number);
	printf("%x\n",number);

	recibido32 = *(unsigned int*) (&buffer3);
				
	nx = *((short int*)(&buffer3)) & 0xFFFF;    
	no = *((short int*)(&(buffer3[2]))) ;
	
	printf("%x    nx = %x    no = %x\n",recibido32, nx, no);
	printf("%x    nx = %x    no = %x\n",recibido32, BinaryToGray(nx), BinaryToGray(no));
	printf("%x    nx = %x    no = %x\n",recibido32, GrayToBinary(BinaryToGray(nx)),GrayToBinary(BinaryToGray(no)));
}

uint GrayToBinary(uint num){
	uint mask = num;
	while(mask){
		mask >>=1;
		num	^= mask;
	}
	return num;
}
uint BinaryToGray(uint num){
	return num ^ (num >> 1);

}
