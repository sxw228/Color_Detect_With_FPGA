#include <iostream>
#include <fstream>
using namespace std;

void main() {
	double num = 1048576;
	int i = 0;
	ofstream file;
	file.open("./Divider_Rom.coe");
	file <<"memory_initialization_radix = 10;"<<endl<<"memory_initialization_vector = ";
	for (i = 17; i < 2048; i++) {
		file << endl<<(int)num / i << "," ;
		cout << "num=" << i << " " << (int)num / i << endl;
	}
	file.close();
}