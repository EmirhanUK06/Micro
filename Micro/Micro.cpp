// Micro.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <conio.h>

extern "C" int testFunction();
extern "C" int Parameter(int a, int b, int c);
extern "C" int Gcd(int a, int b);


using namespace std;

int main()
{
	//cout<<"ASM'den alinan deger " << Parameter(1, 50, 45)<<endl;
	cout << "GCD Degeri: " << Gcd(400, 144) << endl;
	//testFunction();
	_getch();

	return 0;
}