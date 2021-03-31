#include<iostream>
#include "Ui/Include/QtGuiZero00.h"
#include <QtWidgets/QApplication>
using namespace std;

int main(int argc, char* argv[]) {
	QApplication a(argc, argv);
	QtGuiZero00 w;
	w.show();
	return a.exec();
}

 